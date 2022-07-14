CREATE  SCHEMA IF NOT EXISTS scheduler;

CREATE TABLE IF NOT EXISTS scheduler.instance_shutdown (
	schedule_id SERIAL NOT NULL PRIMARY key,
	instance_id VARCHAR(32) NOT NULL,
	shutdown_hour NUMERIC NOT NULL CHECK(shutdown_hour >= 0 AND shutdown_hour < 24),
	unique (instance_id, shutdown_hour)
);

CREATE ROLE kandula
LOGIN
PASSWORD 'kan123';

GRANT USAGE ON SCHEMA scheduler TO kandula;
GRANT USAGE, SELECT ON SEQUENCE scheduler.instance_shutdown_schedule_id_seq TO kandula;
GRANT  INSERT, SELECT, UPDATE, DELETE ON scheduler.instance_shutdown TO kandula;
alter role kandula in database kanduladb set search_path='scheduler';