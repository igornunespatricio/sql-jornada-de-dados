-- Create the employees_audit table
CREATE TABLE IF NOT EXISTS employees_audit (
    id SERIAL PRIMARY KEY,
    employee_id SMALLINT NOT NULL,
    field VARCHAR(50) NOT NULL,
    old_value TEXT,
    new_value TEXT,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_employees_audit_employee FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

-- Create the trigger function
CREATE
OR REPLACE FUNCTION audit_employee_changes() RETURNS TRIGGER AS $$
BEGIN -- Check each column for changes and log them individually
    IF OLD .last_name IS DISTINCT
FROM NEW .last_name THEN
INSERT INTO employees_audit (employee_id, field, old_value, new_value)
VALUES (
        OLD .employee_id,
        'last_name',
        OLD .last_name,
        NEW .last_name
    );

END IF;

IF OLD .first_name IS DISTINCT
FROM NEW .first_name THEN
INSERT INTO employees_audit (employee_id, field, old_value, new_value)
VALUES (
        OLD .employee_id,
        'first_name',
        OLD .first_name,
        NEW .first_name
    );

END IF;

IF OLD .title IS DISTINCT
FROM NEW .title THEN
INSERT INTO employees_audit (employee_id, field, old_value, new_value)
VALUES (
        OLD .employee_id,
        'title',
        OLD .title,
        NEW .title
    );

END IF;

IF OLD .title_of_courtesy IS DISTINCT
FROM NEW .title_of_courtesy THEN
INSERT INTO employees_audit (employee_id, field, old_value, new_value)
VALUES (
        OLD .employee_id,
        'title_of_courtesy',
        OLD .title_of_courtesy,
        NEW .title_of_courtesy
    );

END IF;

IF OLD .birth_date IS DISTINCT
FROM NEW .birth_date THEN
INSERT INTO employees_audit (employee_id, field, old_value, new_value)
VALUES (
        OLD .employee_id,
        'birth_date',
        OLD .birth_date::TEXT,
        NEW .birth_date::TEXT
    );

END IF;

IF OLD .hire_date IS DISTINCT
FROM NEW .hire_date THEN
INSERT INTO employees_audit (employee_id, field, old_value, new_value)
VALUES (
        OLD .employee_id,
        'hire_date',
        OLD .hire_date::TEXT,
        NEW .hire_date::TEXT
    );

END IF;

IF OLD .address IS DISTINCT
FROM NEW .address THEN
INSERT INTO employees_audit (employee_id, field, old_value, new_value)
VALUES (
        OLD .employee_id,
        'address',
        OLD .address,
        NEW .address
    );

END IF;

IF OLD .city IS DISTINCT
FROM NEW .city THEN
INSERT INTO employees_audit (employee_id, field, old_value, new_value)
VALUES (OLD .employee_id, 'city', OLD .city, NEW .city);

END IF;

IF OLD .region IS DISTINCT
FROM NEW .region THEN
INSERT INTO employees_audit (employee_id, field, old_value, new_value)
VALUES (
        OLD .employee_id,
        'region',
        OLD .region,
        NEW .region
    );

END IF;

IF OLD .postal_code IS DISTINCT
FROM NEW .postal_code THEN
INSERT INTO employees_audit (employee_id, field, old_value, new_value)
VALUES (
        OLD .employee_id,
        'postal_code',
        OLD .postal_code,
        NEW .postal_code
    );

END IF;

IF OLD .country IS DISTINCT
FROM NEW .country THEN
INSERT INTO employees_audit (employee_id, field, old_value, new_value)
VALUES (
        OLD .employee_id,
        'country',
        OLD .country,
        NEW .country
    );

END IF;

IF OLD .home_phone IS DISTINCT
FROM NEW .home_phone THEN
INSERT INTO employees_audit (employee_id, field, old_value, new_value)
VALUES (
        OLD .employee_id,
        'home_phone',
        OLD .home_phone,
        NEW .home_phone
    );

END IF;

IF OLD .extension IS DISTINCT
FROM NEW .extension THEN
INSERT INTO employees_audit (employee_id, field, old_value, new_value)
VALUES (
        OLD .employee_id,
        'extension',
        OLD .extension,
        NEW .extension
    );

END IF;

IF OLD .notes IS DISTINCT
FROM NEW .notes THEN
INSERT INTO employees_audit (employee_id, field, old_value, new_value)
VALUES (
        OLD .employee_id,
        'notes',
        OLD .notes,
        NEW .notes
    );

END IF;

IF OLD .reports_to IS DISTINCT
FROM NEW .reports_to THEN
INSERT INTO employees_audit (employee_id, field, old_value, new_value)
VALUES (
        OLD .employee_id,
        'reports_to',
        OLD .reports_to::TEXT,
        NEW .reports_to::TEXT
    );

END IF;

IF OLD .photo_path IS DISTINCT
FROM NEW .photo_path THEN
INSERT INTO employees_audit (employee_id, field, old_value, new_value)
VALUES (
        OLD .employee_id,
        'photo_path',
        OLD .photo_path,
        NEW .photo_path
    );

END IF;

RETURN NEW;

END;

$$ LANGUAGE plpgsql;

-- Create the trigger
CREATE
OR REPLACE TRIGGER trg_employees_audit AFTER
UPDATE ON employees FOR EACH ROW EXECUTE FUNCTION audit_employee_changes();