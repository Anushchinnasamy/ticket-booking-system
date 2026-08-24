package com.ticketbooking.common.config;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.env.EnvironmentPostProcessor;
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
 * A no-op everywhere else — local dev has no DATABASE_URL set, so
 * application.yml's hardcoded jdbc:postgresql://localhost:5432/... is untouched.
 */
public class RenderDatabaseUrlEnvironmentPostProcessor implements EnvironmentPostProcessor {

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
        properties.put("spring.datasource.url", jdbcUrl);
        properties.put("spring.datasource.username", username);
        properties.put("spring.datasource.password", password);

        environment.getPropertySources().addFirst(new MapPropertySource("renderDatabaseUrl", properties));
    }
}
