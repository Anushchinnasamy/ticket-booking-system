package com.ticketbooking.notification.config;

import com.ticketbooking.common.logging.CorrelationIdFilter;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.Ordered;

@Configuration
public class LoggingConfig {

    /**
     * notification-service has no Spring Security filter chain at all (see
     * the note in its pom.xml about not pulling in spring-boot-starter-
     * security), so this just registers as a plain servlet filter —
     * HIGHEST_PRECEDENCE keeps it consistent with the other services even
     * though there's no auth filter to run ahead of here.
     */
    @Bean
    public FilterRegistrationBean<CorrelationIdFilter> correlationIdFilter() {
        FilterRegistrationBean<CorrelationIdFilter> registration =
                new FilterRegistrationBean<>(new CorrelationIdFilter());
        registration.setOrder(Ordered.HIGHEST_PRECEDENCE);
        return registration;
    }
}
