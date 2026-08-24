package com.ticketbooking.common.config;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.env.EnvironmentPostProcessor;
import org.springframework.core.Ordered;
import org.springframework.core.env.ConfigurableEnvironment;
import org.springframework.core.env.MapPropertySource;

import java.net.URI;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * Render's Postgres `connectionString` is a {@code postgres://user:pass@host:port/db}
 * URI, not the {@code jdbc:postgresql://host:port/db} URL Spring's datasource
 * autoconfiguration requires — pointing spring.datasource.url straight at it fails
 * to connect. render.yaml sets the raw connectionString as DATABASE_URL instead of
 * SPRING_DATASOURCE_URL specifically so it doesn't collide with Spring's own
 * property, and this rewrites it into the three properties Spring actually wants,
 * at the highest property-source precedence.
 *
 * Render's free tier also only allows one free Postgres *instance* per account,
 * so all 4 services share that single instance in production, each confined to
 * its own schema via an optional DB_SCHEMA env var — set, it's appended to the
 * JDBC URL as {@code ?currentSchema=...} (scopes Hibernate/JPA's unqualified
 * table access) and also set explicitly as spring.flyway.schemas/default-schema
 * (Flyway creates the schema on first run if it doesn't exist, and keeps its
 * own history table inside it rather than colliding with the other 3 services').
 *
 * A no-op everywhere else — local dev has no DATABASE_URL set, so each
 * service's hardcoded jdbc:postgresql://localhost:5432/<its own db> in
 * application.yml is untouched, and each already has its own real local
 * database rather than needing schema separation at all.
 *
 * Registration gotcha that cost real debugging time: this class was
 * initially registered via META-INF/spring/org.springframework.boot.env
 * .EnvironmentPostProcessor.imports (the newer Spring Boot 2.4+ `.imports`
 * convention) — which silently never ran. That convention is specifically
 * for org.springframework.boot.autoconfigure.AutoConfiguration.imports;
 * Spring Boot 3.3.4's own EnvironmentPostProcessors (ConfigDataEnvironment
 * PostProcessor etc.) are still registered the classic way, confirmed by
 * inspecting spring-boot-3.3.4.jar's own META-INF/spring.factories. Fixed
 * by registering there instead (see common-lib's own META-INF/spring.factories).
 * Verified with an EnvironmentPostProcessor implementing Ordered
 * (LOWEST_PRECEDENCE, so it runs after application.yml is loaded and its
 * addFirst() actually wins) plus a temporary println that confirmed the
 * class runs and jdbc:postgresql://.../app_db_test?currentSchema=event_service
 * ends up as the live spring.datasource.url — then checked Postgres
 * directly and saw the event_service schema created with the service's own
 * tables + its own flyway_schema_history, with public left untouched.
 */
public class RenderDatabaseUrlEnvironmentPostProcessor implements EnvironmentPostProcessor, Ordered {

    @Override
    public int getOrder() {
        return Ordered.LOWEST_PRECEDENCE;
    }

    @Override
    public void postProcessEnvironment(ConfigurableEnvironment environment, SpringApplication application) {
        String databaseUrl = environment.getProperty("DATABASE_URL");
        if (databaseUrl == null || databaseUrl.isBlank()) {
            return;
        }

        URI uri = URI.create(databaseUrl);
        String[] userInfo = uri.getUserInfo() != null ? uri.getUserInfo().split(":", 2) : new String[0];
        String username = userInfo.length > 0 ? userInfo[0] : "";
        String password = userInfo.length > 1 ? userInfo[1] : "";
        String database = uri.getPath() != null && uri.getPath().startsWith("/") ? uri.getPath().substring(1) : uri.getPath();

        String jdbcUrl = "jdbc:postgresql://" + uri.getHost() + ":" + uri.getPort() + "/" + database;

        Map<String, Object> properties = new LinkedHashMap<>();

        String schema = environment.getProperty("DB_SCHEMA");
        if (schema != null && !schema.isBlank()) {
            jdbcUrl += "?currentSchema=" + schema;
            properties.put("spring.flyway.schemas", schema);
            properties.put("spring.flyway.default-schema", schema);
            properties.put("spring.flyway.create-schemas", true);
            properties.put("spring.jpa.properties.hibernate.default_schema", schema);
        }

        properties.put("spring.datasource.url", jdbcUrl);
        properties.put("spring.datasource.username", username);
        properties.put("spring.datasource.password", password);

        environment.getPropertySources().addFirst(new MapPropertySource("renderDatabaseUrl", properties));
    }
}
