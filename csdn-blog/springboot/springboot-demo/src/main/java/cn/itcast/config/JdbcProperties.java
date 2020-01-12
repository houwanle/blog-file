package cn.itcast.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.context.properties.EnableConfigurationProperties;

@SuppressWarnings("ConfigurationProperties")
//@ConfigurationProperties(prefix = "jdbc")
@Data
public class JdbcProperties {

    String url;
    String driverClassName;
    String username;
    String password;

}
