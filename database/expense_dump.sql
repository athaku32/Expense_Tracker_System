--
-- PostgreSQL database dump
--

-- Dumped from database version 14.19 (Homebrew)
-- Dumped by pg_dump version 17.5

-- Started on 2025-11-30 18:02:24 MST

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 4 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: rajputworld
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO rajputworld;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 213 (class 1259 OID 16632)
-- Name: TRANSACTION; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."TRANSACTION" (
    t_transaction_id integer NOT NULL,
    t_user_id integer NOT NULL,
    t_category_id integer NOT NULL,
    t_payment_id integer,
    t_amount numeric(10,2) NOT NULL,
    t_type character varying(20) NOT NULL,
    t_tx_date date NOT NULL,
    t_description character varying(500),
    CONSTRAINT "TRANSACTION_t_amount_check" CHECK ((t_amount > (0)::numeric)),
    CONSTRAINT "TRANSACTION_t_tx_date_check" CHECK ((t_tx_date <= CURRENT_DATE))
);


ALTER TABLE public."TRANSACTION" OWNER TO postgres;

--
-- TOC entry 209 (class 1259 OID 16614)
-- Name: USER; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."USER" (
    u_user_id integer NOT NULL,
    u_name character varying(100) NOT NULL,
    u_email character varying(255) NOT NULL,
    u_password character varying(255) NOT NULL,
    u_join_date date NOT NULL
);


ALTER TABLE public."USER" OWNER TO postgres;

--
-- TOC entry 212 (class 1259 OID 16629)
-- Name: budget; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.budget (
    b_budget_id integer NOT NULL,
    b_user_id integer NOT NULL,
    b_category_id integer NOT NULL,
    b_amount numeric(10,2) NOT NULL,
    b_start_date date NOT NULL,
    b_end_date date NOT NULL,
    CONSTRAINT budget_b_amount_check CHECK ((b_amount > (0)::numeric)),
    CONSTRAINT budget_check CHECK ((b_start_date < b_end_date))
);


ALTER TABLE public.budget OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 16624)
-- Name: category; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.category (
    c_category_id integer NOT NULL,
    c_user_id integer NOT NULL,
    c_category_name character varying(100) NOT NULL,
    c_type character varying(20) NOT NULL,
    c_description character varying(500)
);


ALTER TABLE public.category OWNER TO postgres;

--
-- TOC entry 210 (class 1259 OID 16619)
-- Name: payment_method; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment_method (
    p_payment_id integer NOT NULL,
    p_payment_type character varying(50) NOT NULL,
    p_description character varying(500)
);


ALTER TABLE public.payment_method OWNER TO postgres;

--
-- TOC entry 3819 (class 0 OID 16632)
-- Dependencies: 213
-- Data for Name: TRANSACTION; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."TRANSACTION" (t_transaction_id, t_user_id, t_category_id, t_payment_id, t_amount, t_type, t_tx_date, t_description) FROM stdin;
2	1	2	2	3200.00	Income	2025-11-01	First half of November paycheck deposit
7	1	1	1	34.00	Income	2025-11-18	vending machine phoenix
\.


--
-- TOC entry 3815 (class 0 OID 16614)
-- Dependencies: 209
-- Data for Name: USER; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."USER" (u_user_id, u_name, u_email, u_password, u_join_date) FROM stdin;
1	Sohan Manik	smanik2@asu.edu	Password1	2025-01-15
2	Jose Soto	jmadgeso@asu.edu	Password2	2025-02-10
3	Arshit Thakur	athaku32@asu.edu	Password3	2025-03-05
4	Hoang Nguyen	hunguye1@asu.edu	Password4	2025-11-01
5	Lamine Yamal	lamine.yamal@example.com	hashed_pw_ly	2025-11-20
\.


--
-- TOC entry 3818 (class 0 OID 16629)
-- Dependencies: 212
-- Data for Name: budget; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.budget (b_budget_id, b_user_id, b_category_id, b_amount, b_start_date, b_end_date) FROM stdin;
1	1	1	500.00	2025-11-01	2025-11-30
\.


--
-- TOC entry 3817 (class 0 OID 16624)
-- Dependencies: 211
-- Data for Name: category; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.category (c_category_id, c_user_id, c_category_name, c_type, c_description) FROM stdin;
1	1	Food	Expense	Food and household supplies
2	1	Salary	Income	Monthly salary from employer
3	1	Rent	Expense	Monthly rent payment
4	1	Entertainment	Expense	Money spent on going out with friends
5	1	Transportation	Expense	Money spent on car and other transport
\.


--
-- TOC entry 3816 (class 0 OID 16619)
-- Dependencies: 210
-- Data for Name: payment_method; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payment_method (p_payment_id, p_payment_type, p_description) FROM stdin;
1	Cash	Physical cash payments
2	Credit Card	Credit card payments
3	Debit Card	Debit card payments
4	Apple Pay	Apple Pay payments
5	Bank	Direct wire transfers
6	Miscellaneous	Zelle or Venmo to friends
\.


--
-- TOC entry 3669 (class 2606 OID 16646)
-- Name: TRANSACTION TRANSACTION_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."TRANSACTION"
    ADD CONSTRAINT "TRANSACTION_pkey" PRIMARY KEY (t_transaction_id);


--
-- TOC entry 3655 (class 2606 OID 16638)
-- Name: USER USER_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."USER"
    ADD CONSTRAINT "USER_pkey" PRIMARY KEY (u_user_id);


--
-- TOC entry 3657 (class 2606 OID 16648)
-- Name: USER USER_u_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."USER"
    ADD CONSTRAINT "USER_u_email_key" UNIQUE (u_email);


--
-- TOC entry 3667 (class 2606 OID 16644)
-- Name: budget budget_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.budget
    ADD CONSTRAINT budget_pkey PRIMARY KEY (b_budget_id);


--
-- TOC entry 3663 (class 2606 OID 16650)
-- Name: category category_c_user_id_c_category_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category
    ADD CONSTRAINT category_c_user_id_c_category_name_key UNIQUE (c_user_id, c_category_name);


--
-- TOC entry 3665 (class 2606 OID 16642)
-- Name: category category_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category
    ADD CONSTRAINT category_pkey PRIMARY KEY (c_category_id);


--
-- TOC entry 3659 (class 2606 OID 16652)
-- Name: payment_method payment_method_p_payment_type_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_method
    ADD CONSTRAINT payment_method_p_payment_type_key UNIQUE (p_payment_type);


--
-- TOC entry 3661 (class 2606 OID 16640)
-- Name: payment_method payment_method_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_method
    ADD CONSTRAINT payment_method_pkey PRIMARY KEY (p_payment_id);


--
-- TOC entry 3673 (class 2606 OID 16673)
-- Name: TRANSACTION TRANSACTION_t_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."TRANSACTION"
    ADD CONSTRAINT "TRANSACTION_t_category_id_fkey" FOREIGN KEY (t_category_id) REFERENCES public.category(c_category_id);


--
-- TOC entry 3674 (class 2606 OID 16678)
-- Name: TRANSACTION TRANSACTION_t_payment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."TRANSACTION"
    ADD CONSTRAINT "TRANSACTION_t_payment_id_fkey" FOREIGN KEY (t_payment_id) REFERENCES public.payment_method(p_payment_id);


--
-- TOC entry 3675 (class 2606 OID 16668)
-- Name: TRANSACTION TRANSACTION_t_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."TRANSACTION"
    ADD CONSTRAINT "TRANSACTION_t_user_id_fkey" FOREIGN KEY (t_user_id) REFERENCES public."USER"(u_user_id);


--
-- TOC entry 3671 (class 2606 OID 16663)
-- Name: budget budget_b_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.budget
    ADD CONSTRAINT budget_b_category_id_fkey FOREIGN KEY (b_category_id) REFERENCES public.category(c_category_id);


--
-- TOC entry 3672 (class 2606 OID 16658)
-- Name: budget budget_b_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.budget
    ADD CONSTRAINT budget_b_user_id_fkey FOREIGN KEY (b_user_id) REFERENCES public."USER"(u_user_id);


--
-- TOC entry 3670 (class 2606 OID 16653)
-- Name: category category_c_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category
    ADD CONSTRAINT category_c_user_id_fkey FOREIGN KEY (c_user_id) REFERENCES public."USER"(u_user_id);


--
-- TOC entry 3825 (class 0 OID 0)
-- Dependencies: 4
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: rajputworld
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2025-11-30 18:02:24 MST

--
-- PostgreSQL database dump complete
--

