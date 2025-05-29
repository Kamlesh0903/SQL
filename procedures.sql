-- creation of the tables 

CREATE TABLE employees (
    emp_id NUMBER PRIMARY KEY,
    name VARCHAR2(100),
    salary NUMBER
);


CREATE TABLE salary_history (
    history_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    emp_id NUMBER,
    old_salary NUMBER,
    new_salary NUMBER,
    change_date DATE
);

CREATE OR REPLACE PROCEDURE update_employee_salary (
    p_emp_id      IN NUMBER,
    p_new_salary  IN NUMBER
)
IS
    v_old_salary  NUMBER;
BEGIN
    SELECT salary INTO v_old_salary
    FROM employees
    WHERE emp_id = p_emp_id;

    UPDATE employees
    SET salary = p_new_salary
    WHERE emp_id = p_emp_id;

    INSERT INTO salary_history (emp_id, old_salary, new_salary, change_date)
    VALUES (p_emp_id, v_old_salary, p_new_salary, SYSDATE);

    COMMIT;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Employee not found.');
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/


-- calling the procedure 

BEGIN
    update_employee_salary(101, 75000);
END;
/
