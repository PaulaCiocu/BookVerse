package com.licenta.bookverse.config;
import com.licenta.bookverse.repository.PersonRepository;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.web.client.RestTemplate;

@Configuration
@EnableWebSecurity
public class ApplicationConfig {
    private final PersonRepository personRepository;
    public ApplicationConfig(PersonRepository personRepository) {
        this.personRepository = personRepository;
    }
    @Bean
    public RestTemplate restTemplate() {
        return new RestTemplate();
    }
}
