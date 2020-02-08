--departments table start
CREATE TABLE public.departments
(
    dept_no character(4) COLLATE pg_catalog."default" NOT NULL,
    dept_name character(30) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT departments_pkey PRIMARY KEY (dept_no)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.departments
    OWNER to postgres;
COMMENT ON TABLE public.departments
    IS 'departments table';

--departments table end

--dep_emp table start
CREATE TABLE public.dept_emp
(
    dept_no character(4) COLLATE pg_catalog."default" NOT NULL,
    from_date date NOT NULL,
    to_date date NOT NULL,
    dept_emp_pk bigint NOT NULL DEFAULT nextval('dept_emp_tbl_index_seq'::regclass),
    emp_no integer NOT NULL,
    CONSTRAINT dep_emp_pk PRIMARY KEY (dept_emp_pk),
    CONSTRAINT fk_dept_emp FOREIGN KEY (dept_no)
        REFERENCES public.departments (dept_no) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_emp_tbl FOREIGN KEY (emp_no)
        REFERENCES public.employees (emp_no) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

--dep_emp table end

--dept_manager start
CREATE TABLE public.dept_manager
(
    dept_no character(4) COLLATE pg_catalog."default" NOT NULL,
    from_date date NOT NULL,
    to_date date NOT NULL,
    emp_no integer NOT NULL,
    dept_emp_pk integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    CONSTRAINT dept_manager_pkey PRIMARY KEY (dept_emp_pk),
    CONSTRAINT fk_dept_mgrs FOREIGN KEY (dept_no)
        REFERENCES public.departments (dept_no) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_emp2_tbl FOREIGN KEY (emp_no)
        REFERENCES public.employees (emp_no) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.dept_manager
    OWNER to postgres;

-- Index: dm_4cols

-- DROP INDEX public.dm_4cols;

CREATE UNIQUE INDEX dm_4cols
    ON public.dept_manager USING btree

--dept_manager end

--employees start
CREATE TABLE public.employees
(
    emp_no integer NOT NULL,
    birth_date date NOT NULL,
    first_name character(30) COLLATE pg_catalog."default" NOT NULL,
    last_name character(30) COLLATE pg_catalog."default" NOT NULL,
    gender character(1) COLLATE pg_catalog."default" NOT NULL,
    hire_date date NOT NULL,
    CONSTRAINT employee_pkey PRIMARY KEY (emp_no)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.employees
    OWNER to postgres;
--employees end

--salaries start

CREATE TABLE public.salaries
(
    salaries_pk bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 500 MINVALUE 500 MAXVALUE 9223372036854775807 CACHE 1 ),
    emp_no integer NOT NULL,
    salary money NOT NULL,
    from_date date NOT NULL,
    to_date date NOT NULL,
    CONSTRAINT salaries_pk PRIMARY KEY (salaries_pk)
        INCLUDE(salaries_pk),
    CONSTRAINT emp_no FOREIGN KEY (emp_no)
        REFERENCES public.employees (emp_no) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;


--salaries end

--titles start
CREATE TABLE public.titles
(
    titles_pk bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    emp_no integer NOT NULL,
    title character varying COLLATE pg_catalog."default" NOT NULL,
    from_date date NOT NULL,
    to_date date NOT NULL,
    CONSTRAINT tiles_pk_seq PRIMARY KEY (titles_pk)
        INCLUDE(titles_pk),
    CONSTRAINT emp_no FOREIGN KEY (emp_no)
        REFERENCES public.employees (emp_no) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

--titles end



--dep_emp table end