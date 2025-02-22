## https://docs.sonarsource.com/sonarqube/latest/setup-and-upgrade/install-the-server/installing-sonarqube-from-docker/

services:
  sonarqube:
    deploy:
      replicas: 3
    healthcheck:
      test: wget --no-proxy -qO- http://localhost:9000/api/system/status | grep -q -e '"status":"UP"' -e '"status":"DB_MIGRATION_NEEDED"' -e '"status":"DB_MIGRATION_RUNNING"'
      interval: 25s
      timeout: 1s
      retries: 3
      start_period: 55s
    image: sonarqube:datacenter-app
    read_only: true
    depends_on:
      search-1:
        condition: service_healthy
      search-2:
        condition: service_healthy
      search-3:
        condition: service_healthy
      db:
        condition: service_healthy
    networks:
      - sonar-network
    cpus: 0.5
    mem_limit: 4096M
    mem_reservation: 4096M
    environment:
      SONAR_JDBC_URL: jdbc:postgresql://db:5432/sonar
      SONAR_JDBC_USERNAME: sonar
      SONAR_JDBC_PASSWORD: sonar
      SONAR_WEB_PORT: 9000
      SONAR_CLUSTER_SEARCH_HOSTS: "search-1,search-2,search-3"
      SONAR_CLUSTER_HOSTS: "sonarqube"
      SONAR_CLUSTER_KUBERNETES: true
      SONAR_AUTH_JWTBASE64HS256SECRET: "dZ0EB0KxnF++nr5+4vfTCaun/eWbv6gOoXodiAMqcFo="
      VIRTUAL_HOST: sonarqube.dev.local
      VIRTUAL_PORT: 9000
    volumes:
      - sonarqube_extensions:/opt/sonarqube/extensions
      - sonarqube_logs:/opt/sonarqube/logs
      - sonarqube_temp:/opt/sonarqube/temp
      - /opt/sonarqube/data
  search-1:
    image: sonarqube:datacenter-search
    read_only: true
    hostname: "search-1"
    cpus: 0.5
    mem_limit: 3072M
    mem_reservation: 3072M
    depends_on:
      db:
        condition: service_healthy
    networks:
      - sonar-network
    environment:
      SONAR_JDBC_URL: jdbc:postgresql://db:5432/sonar
      SONAR_JDBC_USERNAME: sonar
      SONAR_JDBC_PASSWORD: sonar
      SONAR_CLUSTER_ES_HOSTS: "search-1,search-2,search-3"
      SONAR_CLUSTER_NODE_NAME: "search-1"
    volumes:
      - search_data-1:/opt/sonarqube/data
      - sonarqube_logs:/opt/sonarqube/logs
      - search_temp-1:/opt/sonarqube/temp
      - search_logs-1:/opt/sonarqube/logs
    healthcheck:
        test: wget --no-proxy -qO- "http://$$SONAR_CLUSTER_NODE_NAME:9001/_cluster/health?wait_for_status=yellow&timeout=50s" | grep -q -e '"status":"green"' -e '"status":"yellow"';  if [ $? -eq 0 ]; then exit 0; else exit 1; fi
        interval: 25s
        timeout: 1s
        retries: 3
        start_period: 55s
  search-2:
    image: sonarqube:datacenter-search
    read_only: true
    hostname: "search-2"
    cpus: 0.5
    mem_limit: 3072M
    mem_reservation: 3072M
    depends_on:
      db:
        condition: service_healthy
    networks:
      - sonar-network
    environment:
      SONAR_JDBC_URL: jdbc:postgresql://db:5432/sonar
      SONAR_JDBC_USERNAME: sonar
      SONAR_JDBC_PASSWORD: sonar
      SONAR_CLUSTER_ES_HOSTS: "search-1,search-2,search-3"
      SONAR_CLUSTER_NODE_NAME: "search-2"
    volumes:
      - search_data-2:/opt/sonarqube/data
      - sonarqube_logs:/opt/sonarqube/logs
      - search_temp-2:/opt/sonarqube/temp
      - search_logs-2:/opt/sonarqube/logs
    healthcheck:
        test: wget --no-proxy -qO- "http://$$SONAR_CLUSTER_NODE_NAME:9001/_cluster/health?wait_for_status=yellow&timeout=50s" | grep -q -e '"status":"green"' -e '"status":"yellow"';  if [ $? -eq 0 ]; then exit 0; else exit 1; fi
        interval: 25s
        timeout: 1s
        retries: 3
        start_period: 55s
  search-3:
    image: sonarqube:datacenter-search
    read_only: true
    hostname: "search-3"
    cpus: 0.5
    mem_limit: 3072M
    mem_reservation: 3072M
    depends_on:
      db:
        condition: service_healthy
    networks:
      - sonar-network
    environment:
      SONAR_JDBC_URL: jdbc:postgresql://db:5432/sonar
      SONAR_JDBC_USERNAME: sonar
      SONAR_JDBC_PASSWORD: sonar
      SONAR_CLUSTER_ES_HOSTS: "search-1,search-2,search-3"
      SONAR_CLUSTER_NODE_NAME: "search-3"
    volumes:
      - search_data-3:/opt/sonarqube/data
      - sonarqube_logs:/opt/sonarqube/logs
      - search_temp-3:/opt/sonarqube/temp
      - search_logs-3:/opt/sonarqube/logs
    healthcheck:
        test: wget --no-proxy -qO- "http://$$SONAR_CLUSTER_NODE_NAME:9001/_cluster/health?wait_for_status=yellow&timeout=50s" | grep -q -e '"status":"green"' -e '"status":"yellow"';  if [ $? -eq 0 ]; then exit 0; else exit 1; fi
        interval: 25s
        timeout: 1s
        retries: 3
        start_period: 55s
  db:
    image: postgres:15
    healthcheck:
      test: ["CMD-SHELL", "pg_isready"]
      interval: 10s
      timeout: 5s
      retries: 5
    networks:
      - sonar-network
    environment:
      POSTGRES_USER: sonar
      POSTGRES_PASSWORD: sonar
    volumes:
      - postgresql:/var/lib/postgresql
      - postgresql_data:/var/lib/postgresql/data
  proxy:
    image: jwilder/nginx-proxy
    ports:
      - "80:80"
    volumes:
      - /var/run/docker.sock:/tmp/docker.sock:ro
      - ./unrestricted_client_body_size.conf:/etc/nginx/conf.d/unrestricted_client_body_size.conf:ro
    networks:
      - sonar-network
      - sonar-public

networks:
  sonar-network:
    ipam:
      driver: default
      config:
        - subnet: 172.28.2.0/24
  sonar-public:
    driver: bridge

volumes:
  sonarqube_extensions:
  sonarqube_logs:
  search_logs-1:
  search_logs-2:
  search_logs-3:
  search_data-1:
  search_data-2:
  search_data-3:
  search_temp-1:
  search_temp-2:
  search_temp-3:
  sonarqube_temp:
  postgresql:
  postgresql_data: