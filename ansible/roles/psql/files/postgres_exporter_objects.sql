
ALTER USER postgres_exporter SET SEARCH_PATH TO public,pg_catalog;
GRANT CONNECT ON DATABASE postgres TO postgres_exporter;
GRANT pg_monitor to postgres_exporter;