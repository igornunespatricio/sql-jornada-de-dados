CREATE
OR REPLACE FUNCTION func_update_materialized_view() RETURNS TRIGGER AS $$
BEGIN REFRESH MATERIALIZED VIEW mv_monthly_revenue;

RETURN NULL;

END;

$$ LANGUAGE plpgsql;

CREATE
OR REPLACE TRIGGER trg_update_materialized_view_order AFTER
INSERT
    OR
UPDATE
    OR
DELETE ON orders FOR EACH STATEMENT EXECUTE FUNCTION func_update_materialized_view();

CREATE
OR REPLACE TRIGGER trg_update_materialized_view_order_details AFTER
INSERT
    OR
UPDATE
    OR
DELETE ON order_details FOR EACH STATEMENT EXECUTE FUNCTION func_update_materialized_view();