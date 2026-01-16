-- Initialize PostgreSQL database for Phase 3 services

-- Create databases for each service
CREATE DATABASE vikunja;
CREATE DATABASE hedgedoc;
CREATE DATABASE linkding;
CREATE DATABASE navidrome;

-- Create users for each service
CREATE USER vikunja WITH PASSWORD 'vikunja_password';
CREATE USER hedgedoc WITH PASSWORD 'hedgedoc_password';
CREATE USER linkding WITH PASSWORD 'linkding_password';
CREATE USER navidrome WITH PASSWORD 'navidrome_password';

-- Grant privileges to create schemas and tables
GRANT ALL PRIVILEGES ON DATABASE vikunja TO vikunja;
GRANT ALL PRIVILEGES ON DATABASE hedgedoc TO hedgedoc;
GRANT ALL PRIVILEGES ON DATABASE linkding TO linkding;
GRANT ALL PRIVILEGES ON DATABASE navidrome TO navidrome;

-- Connect to each database and grant schema privileges
\c vikunja;
GRANT ALL PRIVILEGES ON SCHEMA public TO vikunja;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO vikunja;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO vikunja;

\c hedgedoc;
GRANT ALL PRIVILEGES ON SCHEMA public TO hedgedoc;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO hedgedoc;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO hedgedoc;

\c linkding;
GRANT ALL PRIVILEGES ON SCHEMA public TO linkding;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO linkding;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO linkding;

\c navidrome;
GRANT ALL PRIVILEGES ON SCHEMA public TO navidrome;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO navidrome;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO navidrome;

-- Connect to homelab database and create initial schema
\c homelab;

-- Create service configuration table
CREATE TABLE IF NOT EXISTS service_configs (
    id SERIAL PRIMARY KEY,
    service_name VARCHAR(50) UNIQUE NOT NULL,
    database_name VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert initial service configurations
INSERT INTO service_configs (service_name, database_name) VALUES
('vikunja', 'vikunja'),
('hedgedoc', 'hedgedoc'),
('linkding', 'linkding'),
('navidrome', 'navidrome');

-- Create backup tracking table
CREATE TABLE IF NOT EXISTS backup_log (
    id SERIAL PRIMARY KEY,
    service_name VARCHAR(50) NOT NULL,
    backup_type VARCHAR(20) NOT NULL,
    backup_path VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    success BOOLEAN DEFAULT true
);

-- Create user activity log for audit trail
CREATE TABLE IF NOT EXISTS user_activity (
    id SERIAL PRIMARY KEY,
    service_name VARCHAR(50) NOT NULL,
    action VARCHAR(100) NOT NULL,
    user_identifier VARCHAR(100),
    ip_address INET,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_service_configs_service_name ON service_configs(service_name);
CREATE INDEX IF NOT EXISTS idx_backup_log_service_name ON backup_log(service_name);
CREATE INDEX IF NOT EXISTS idx_backup_log_created_at ON backup_log(created_at);
CREATE INDEX IF NOT EXISTS idx_user_activity_service_name ON user_activity(service_name);
CREATE INDEX IF NOT EXISTS idx_user_activity_created_at ON user_activity(created_at);

-- Create view for service status
CREATE OR REPLACE VIEW service_status AS
SELECT 
    sc.service_name,
    sc.database_name,
    sc.created_at as setup_date,
    CASE 
        WHEN EXISTS (
            SELECT 1 FROM pg_stat_activity 
            WHERE datname = sc.database_name 
            AND state = 'active'
        ) THEN 'active'
        ELSE 'inactive'
    END as status,
    pg_size_pretty(pg_database_size(sc.database_name)) as database_size
FROM service_configs sc;

-- Grant read access to service status view
GRANT SELECT ON service_status TO vikunja;
GRANT SELECT ON service_status TO hedgedoc;
GRANT SELECT ON service_status TO linkding;
GRANT SELECT ON service_status TO navidrome;

-- Create function for logging user activity
CREATE OR REPLACE FUNCTION log_user_activity(
    p_service_name VARCHAR(50),
    p_action VARCHAR(100),
    p_user_identifier VARCHAR(100),
    p_ip_address INET
) RETURNS VOID AS $$
BEGIN
    INSERT INTO user_activity (service_name, action, user_identifier, ip_address)
    VALUES (p_service_name, p_action, p_user_identifier, p_ip_address);
END;
$$ LANGUAGE plpgsql;

-- Grant execute permission to all service users
GRANT EXECUTE ON FUNCTION log_user_activity TO vikunja;
GRANT EXECUTE ON FUNCTION log_user_activity TO hedgedoc;
GRANT EXECUTE ON FUNCTION log_user_activity TO linkding;
GRANT EXECUTE ON FUNCTION log_user_activity TO navidrome;

COMMIT;
