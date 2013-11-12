--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

SET search_path = public, pg_catalog;

SET default_with_oids = false;

--
-- Name: addresses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE addresses (
    addresses_id integer NOT NULL,
    users_id integer NOT NULL,
    type character varying(16) DEFAULT ''::character varying NOT NULL,
    archived boolean DEFAULT false NOT NULL,
    first_name character varying(255) DEFAULT ''::character varying NOT NULL,
    last_name character varying(255) DEFAULT ''::character varying NOT NULL,
    company character varying(255) DEFAULT ''::character varying NOT NULL,
    address character varying(255) DEFAULT ''::character varying NOT NULL,
    address_2 character varying(255) DEFAULT ''::character varying NOT NULL,
    zip character varying(255) DEFAULT ''::character varying NOT NULL,
    city character varying(255) DEFAULT ''::character varying NOT NULL,
    phone character varying(32) DEFAULT ''::character varying NOT NULL,
    state_code character(6) DEFAULT ''::bpchar NOT NULL,
    country_code character(2) DEFAULT ''::bpchar NOT NULL,
    created timestamp without time zone NOT NULL,
    last_modified timestamp without time zone NOT NULL
);


--
-- Name: addresses_addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE addresses_addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: addresses_addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE addresses_addresses_id_seq OWNED BY addresses.addresses_id;


--
-- Name: addresses_addresses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('addresses_addresses_id_seq', 13, true);


--
-- Name: cart_products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE cart_products (
    carts_id integer NOT NULL,
    sku character varying(32) NOT NULL,
    cart_position integer NOT NULL,
    quantity integer DEFAULT 1 NOT NULL,
    when_added timestamp without time zone NOT NULL
);


--
-- Name: carts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE carts (
    carts_id integer NOT NULL,
    name character varying(255) DEFAULT ''::character varying NOT NULL,
    users_id integer NOT NULL,
    sessions_id character varying(255) NOT NULL,
    created timestamp without time zone NOT NULL,
    last_modified timestamp without time zone NOT NULL,
    approved boolean,
    status character varying(32) DEFAULT ''::character varying NOT NULL
);


--
-- Name: carts_carts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE carts_carts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: carts_carts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE carts_carts_id_seq OWNED BY carts.carts_id;


--
-- Name: carts_carts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('carts_carts_id_seq', 4, true);


--
-- Name: group_pricing; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE group_pricing (
    group_pricing_id integer NOT NULL,
    sku character varying(32) NOT NULL,
    quantity integer DEFAULT 0 NOT NULL,
    roles_id integer NOT NULL,
    price numeric(10,2) DEFAULT 0.0 NOT NULL
);


--
-- Name: group_pricing_group_pricing_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE group_pricing_group_pricing_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: group_pricing_group_pricing_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE group_pricing_group_pricing_id_seq OWNED BY group_pricing.group_pricing_id;


--
-- Name: group_pricing_group_pricing_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('group_pricing_group_pricing_id_seq', 3, true);


--
-- Name: inventory; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE inventory (
    sku character varying(32) NOT NULL,
    quantity integer DEFAULT 0 NOT NULL
);


--
-- Name: media; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE media (
    media_id integer NOT NULL,
    file character varying(255) DEFAULT ''::character varying NOT NULL,
    uri character varying(255) DEFAULT ''::character varying NOT NULL,
    mime_type character varying(255) DEFAULT ''::character varying NOT NULL,
    label character varying(255) DEFAULT ''::character varying NOT NULL,
    author integer DEFAULT 0 NOT NULL,
    created timestamp without time zone NOT NULL,
    last_modified timestamp without time zone NOT NULL,
    active boolean DEFAULT true NOT NULL
);


--
-- Name: media_displays; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE media_displays (
    media_displays_id integer NOT NULL,
    media_id integer NOT NULL,
    sku character varying(32) NOT NULL,
    media_types_id integer NOT NULL
);


--
-- Name: media_displays_media_displays_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE media_displays_media_displays_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: media_displays_media_displays_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE media_displays_media_displays_id_seq OWNED BY media_displays.media_displays_id;


--
-- Name: media_displays_media_displays_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('media_displays_media_displays_id_seq', 2, true);


--
-- Name: media_media_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE media_media_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: media_media_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE media_media_id_seq OWNED BY media.media_id;


--
-- Name: media_media_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('media_media_id_seq', 7, true);


--
-- Name: media_products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE media_products (
    media_products_id integer NOT NULL,
    media_id integer NOT NULL,
    sku character varying(32) NOT NULL
);


--
-- Name: media_products_media_products_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE media_products_media_products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: media_products_media_products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE media_products_media_products_id_seq OWNED BY media_products.media_products_id;


--
-- Name: media_products_media_products_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('media_products_media_products_id_seq', 2, true);


--
-- Name: media_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE media_types (
    media_types_id integer NOT NULL,
    type character varying(32) NOT NULL
);


--
-- Name: media_types_media_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE media_types_media_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: media_types_media_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE media_types_media_types_id_seq OWNED BY media_types.media_types_id;


--
-- Name: media_types_media_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('media_types_media_types_id_seq', 7, true);


--
-- Name: merchandising_attributes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE merchandising_attributes (
    merchandising_attributes_id integer NOT NULL,
    merchandising_products_id integer NOT NULL,
    name character varying(32) NOT NULL,
    value text DEFAULT ''::text NOT NULL
);


--
-- Name: merchandising_attributes_merchandising_attributes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE merchandising_attributes_merchandising_attributes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: merchandising_attributes_merchandising_attributes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE merchandising_attributes_merchandising_attributes_id_seq OWNED BY merchandising_attributes.merchandising_attributes_id;


--
-- Name: merchandising_attributes_merchandising_attributes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('merchandising_attributes_merchandising_attributes_id_seq', 3, true);


--
-- Name: merchandising_products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE merchandising_products (
    merchandising_products_id integer NOT NULL,
    sku character varying(32),
    sku_related character varying(32),
    type character varying(32) DEFAULT ''::character varying NOT NULL
);


--
-- Name: merchandising_products_merchandising_products_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE merchandising_products_merchandising_products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: merchandising_products_merchandising_products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE merchandising_products_merchandising_products_id_seq OWNED BY merchandising_products.merchandising_products_id;


--
-- Name: merchandising_products_merchandising_products_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('merchandising_products_merchandising_products_id_seq', 6, true);


--
-- Name: navigation; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE navigation (
    navigation_id integer NOT NULL,
    uri character varying(255) DEFAULT ''::character varying NOT NULL,
    type character varying(32) DEFAULT ''::character varying NOT NULL,
    scope character varying(32) DEFAULT ''::character varying NOT NULL,
    name character varying(255) DEFAULT ''::character varying NOT NULL,
    description text DEFAULT ''::text NOT NULL,
    template character varying(255) DEFAULT ''::character varying NOT NULL,
    alias integer DEFAULT 0 NOT NULL,
    parent integer DEFAULT 0 NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    product_count integer DEFAULT 0 NOT NULL,
    active boolean DEFAULT true NOT NULL,
    entered timestamp without time zone DEFAULT now()
);


--
-- Name: navigation_navigation_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE navigation_navigation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: navigation_navigation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE navigation_navigation_id_seq OWNED BY navigation.navigation_id;


--
-- Name: navigation_navigation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('navigation_navigation_id_seq', 6, true);


--
-- Name: navigation_products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE navigation_products (
    sku character varying(32) NOT NULL,
    navigation_id integer NOT NULL,
    type character varying(16) DEFAULT ''::character varying NOT NULL
);


--
-- Name: orderlines; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE orderlines (
    orderlines_id integer NOT NULL,
    order_number character varying(24) NOT NULL,
    order_position integer DEFAULT 0 NOT NULL,
    sku character varying(32) NOT NULL,
    name character varying(255) DEFAULT ''::character varying NOT NULL,
    short_description character varying(500) DEFAULT ''::character varying NOT NULL,
    description text DEFAULT ''::text NOT NULL,
    weight numeric DEFAULT 0.0 NOT NULL,
    quantity integer,
    shipping_method character varying(255) DEFAULT ''::character varying NOT NULL,
    tracking_number character varying(255) DEFAULT ''::character varying NOT NULL,
    price numeric(10,2) DEFAULT 0.0 NOT NULL,
    subtotal numeric(11,2) DEFAULT 0.0 NOT NULL,
    shipping numeric(11,2) DEFAULT 0.0 NOT NULL,
    handling numeric(11,2) DEFAULT 0.0 NOT NULL,
    salestax numeric(11,2) DEFAULT 0.0 NOT NULL,
    status character varying(24) DEFAULT ''::character varying NOT NULL
);


--
-- Name: orderlines_orderlines_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE orderlines_orderlines_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: orderlines_orderlines_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE orderlines_orderlines_id_seq OWNED BY orderlines.orderlines_id;


--
-- Name: orderlines_orderlines_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('orderlines_orderlines_id_seq', 4, true);


--
-- Name: orderlines_shipping; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE orderlines_shipping (
    orderlines_id integer NOT NULL,
    addresses_id integer NOT NULL
);


--
-- Name: orders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE orders (
    orders_id integer NOT NULL,
    order_number character varying(24) NOT NULL,
    order_date timestamp without time zone,
    users_id integer NOT NULL,
    email character varying(255) DEFAULT ''::character varying NOT NULL,
    billing_addresses_id integer NOT NULL,
    weight numeric DEFAULT 0.0 NOT NULL,
    payment_method character varying(255) DEFAULT ''::character varying NOT NULL,
    payment_number character varying(255) DEFAULT ''::character varying NOT NULL,
    payment_status character varying(255) DEFAULT ''::character varying NOT NULL,
    shipping_method character varying(255) DEFAULT ''::character varying NOT NULL,
    tracking_number character varying(255) DEFAULT ''::character varying NOT NULL,
    subtotal numeric(11,2) DEFAULT 0.0 NOT NULL,
    shipping numeric(11,2) DEFAULT 0.0 NOT NULL,
    handling numeric(11,2) DEFAULT 0.0 NOT NULL,
    salestax numeric(11,2) DEFAULT 0.0 NOT NULL,
    total_cost numeric(11,2) DEFAULT 0.0 NOT NULL,
    status character varying(24) DEFAULT ''::character varying NOT NULL
);


--
-- Name: orders_orders_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE orders_orders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: orders_orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE orders_orders_id_seq OWNED BY orders.orders_id;


--
-- Name: orders_orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('orders_orders_id_seq', 9, true);


--
-- Name: payment_orders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE payment_orders (
    payment_orders_id integer NOT NULL,
    payment_mode character varying(32) DEFAULT ''::character varying NOT NULL,
    payment_action character varying(32) DEFAULT ''::character varying NOT NULL,
    payment_id character varying(32) DEFAULT ''::character varying NOT NULL,
    auth_code character varying(255) DEFAULT ''::character varying NOT NULL,
    sessions_id character varying(255) NOT NULL,
    order_number character varying(24) NOT NULL,
    amount numeric(11,2) DEFAULT 0.0 NOT NULL,
    status character varying(32) DEFAULT ''::character varying NOT NULL,
    payment_sessions_id character varying(255) DEFAULT ''::character varying NOT NULL,
    payment_error_code character varying(32) DEFAULT ''::character varying NOT NULL,
    payment_error_message text DEFAULT ''::text NOT NULL,
    created timestamp without time zone,
    last_modified timestamp without time zone
);


--
-- Name: payment_orders_payment_orders_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE payment_orders_payment_orders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: payment_orders_payment_orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE payment_orders_payment_orders_id_seq OWNED BY payment_orders.payment_orders_id;


--
-- Name: payment_orders_payment_orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('payment_orders_payment_orders_id_seq', 2, true);


--
-- Name: permissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE permissions (
    roles_id integer NOT NULL,
    perm character varying(255) DEFAULT ''::character varying NOT NULL
);


--
-- Name: product_attributes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE product_attributes (
    product_attributes_id integer NOT NULL,
    name character varying(32) NOT NULL,
    value text DEFAULT ''::text NOT NULL
);


--
-- Name: product_attributes_product_attributes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE product_attributes_product_attributes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: product_attributes_product_attributes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE product_attributes_product_attributes_id_seq OWNED BY product_attributes.product_attributes_id;


--
-- Name: product_attributes_product_attributes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('product_attributes_product_attributes_id_seq', 6, true);


--
-- Name: product_classes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE product_classes (
    sku_class character varying(32) NOT NULL,
    manufacturer character varying(128) DEFAULT ''::character varying NOT NULL,
    name character varying(255) DEFAULT ''::character varying NOT NULL,
    short_description character varying(255) DEFAULT ''::character varying NOT NULL,
    uri character varying(500) DEFAULT ''::character varying NOT NULL,
    active boolean DEFAULT true NOT NULL
);


--
-- Name: products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE products (
    sku character varying(32) NOT NULL,
    sku_class character varying(32) NOT NULL,
    name character varying(255) DEFAULT ''::character varying NOT NULL,
    short_description character varying(500) DEFAULT ''::character varying NOT NULL,
    description text DEFAULT ''::text NOT NULL,
    price numeric(10,2) DEFAULT 0.0 NOT NULL,
    uri character varying(255) DEFAULT ''::character varying NOT NULL,
    weight numeric DEFAULT 0.0 NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    gtin character varying(32) DEFAULT ''::character varying NOT NULL,
    canonical_sku character varying(32) DEFAULT ''::character varying NOT NULL,
    active boolean DEFAULT true NOT NULL,
    inventory_exempt boolean DEFAULT false NOT NULL
);


--
-- Name: products_attributes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE products_attributes (
    sku character varying(32) NOT NULL,
    product_attributes_id integer NOT NULL
);


--
-- Name: roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE roles (
    roles_id integer NOT NULL,
    name character varying(32) NOT NULL,
    label character varying(255) NOT NULL
);


--
-- Name: roles_roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE roles_roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: roles_roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE roles_roles_id_seq OWNED BY roles.roles_id;


--
-- Name: roles_roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('roles_roles_id_seq', 14, true);


--
-- Name: sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE sessions (
    sessions_id character varying(255) NOT NULL,
    session_data text NOT NULL,
    session_hash text NOT NULL,
    created timestamp without time zone NOT NULL,
    last_modified timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE settings (
    settings_id integer NOT NULL,
    scope character varying(32) NOT NULL,
    site character varying(32) DEFAULT ''::character varying NOT NULL,
    name character varying(32) NOT NULL,
    value text NOT NULL,
    category character varying(32) DEFAULT ''::character varying NOT NULL
);


--
-- Name: settings_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE settings_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: settings_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE settings_settings_id_seq OWNED BY settings.settings_id;


--
-- Name: settings_settings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('settings_settings_id_seq', 3, true);


--
-- Name: user_attributes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE user_attributes (
    user_attributes_id integer NOT NULL,
    users_id integer NOT NULL,
    name character varying(32) NOT NULL,
    value text DEFAULT ''::text NOT NULL
);


--
-- Name: user_attributes_user_attributes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE user_attributes_user_attributes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: user_attributes_user_attributes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE user_attributes_user_attributes_id_seq OWNED BY user_attributes.user_attributes_id;


--
-- Name: user_attributes_user_attributes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('user_attributes_user_attributes_id_seq', 2, true);


--
-- Name: user_roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE user_roles (
    users_id integer NOT NULL,
    roles_id integer NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE users (
    users_id integer NOT NULL,
    username character varying(255) NOT NULL,
    email character varying(255) DEFAULT ''::character varying NOT NULL,
    password character varying(255) DEFAULT ''::character varying NOT NULL,
    first_name character varying(255) DEFAULT ''::character varying NOT NULL,
    last_name character varying(255) DEFAULT ''::character varying NOT NULL,
    last_login timestamp without time zone NOT NULL,
    created timestamp without time zone NOT NULL,
    last_modified timestamp without time zone NOT NULL,
    active boolean DEFAULT true NOT NULL
);


--
-- Name: users_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: users_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_users_id_seq OWNED BY users.users_id;


--
-- Name: users_users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('users_users_id_seq', 34, true);


--
-- Name: addresses_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY addresses ALTER COLUMN addresses_id SET DEFAULT nextval('addresses_addresses_id_seq'::regclass);


--
-- Name: carts_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY carts ALTER COLUMN carts_id SET DEFAULT nextval('carts_carts_id_seq'::regclass);


--
-- Name: group_pricing_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY group_pricing ALTER COLUMN group_pricing_id SET DEFAULT nextval('group_pricing_group_pricing_id_seq'::regclass);


--
-- Name: media_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY media ALTER COLUMN media_id SET DEFAULT nextval('media_media_id_seq'::regclass);


--
-- Name: media_displays_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY media_displays ALTER COLUMN media_displays_id SET DEFAULT nextval('media_displays_media_displays_id_seq'::regclass);


--
-- Name: media_products_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY media_products ALTER COLUMN media_products_id SET DEFAULT nextval('media_products_media_products_id_seq'::regclass);


--
-- Name: media_types_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY media_types ALTER COLUMN media_types_id SET DEFAULT nextval('media_types_media_types_id_seq'::regclass);


--
-- Name: merchandising_attributes_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY merchandising_attributes ALTER COLUMN merchandising_attributes_id SET DEFAULT nextval('merchandising_attributes_merchandising_attributes_id_seq'::regclass);


--
-- Name: merchandising_products_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY merchandising_products ALTER COLUMN merchandising_products_id SET DEFAULT nextval('merchandising_products_merchandising_products_id_seq'::regclass);


--
-- Name: navigation_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY navigation ALTER COLUMN navigation_id SET DEFAULT nextval('navigation_navigation_id_seq'::regclass);


--
-- Name: orderlines_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY orderlines ALTER COLUMN orderlines_id SET DEFAULT nextval('orderlines_orderlines_id_seq'::regclass);


--
-- Name: orders_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY orders ALTER COLUMN orders_id SET DEFAULT nextval('orders_orders_id_seq'::regclass);


--
-- Name: payment_orders_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY payment_orders ALTER COLUMN payment_orders_id SET DEFAULT nextval('payment_orders_payment_orders_id_seq'::regclass);


--
-- Name: product_attributes_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY product_attributes ALTER COLUMN product_attributes_id SET DEFAULT nextval('product_attributes_product_attributes_id_seq'::regclass);


--
-- Name: roles_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY roles ALTER COLUMN roles_id SET DEFAULT nextval('roles_roles_id_seq'::regclass);


--
-- Name: settings_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY settings ALTER COLUMN settings_id SET DEFAULT nextval('settings_settings_id_seq'::regclass);


--
-- Name: user_attributes_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_attributes ALTER COLUMN user_attributes_id SET DEFAULT nextval('user_attributes_user_attributes_id_seq'::regclass);


--
-- Name: users_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN users_id SET DEFAULT nextval('users_users_id_seq'::regclass);


--
-- Data for Name: addresses; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: cart_products; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: carts; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: group_pricing; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: inventory; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: media; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: media_displays; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: media_products; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: media_types; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO media_types (media_types_id, type) VALUES (1, 'detail');
INSERT INTO media_types (media_types_id, type) VALUES (2, 'thumb');
INSERT INTO media_types (media_types_id, type) VALUES (3, 'cart');


--
-- Data for Name: merchandising_attributes; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: merchandising_products; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: navigation; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: navigation_products; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: orderlines; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: orderlines_shipping; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: payment_orders; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: permissions; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO permissions (roles_id, perm) VALUES (1, 'anonymous');
INSERT INTO permissions (roles_id, perm) VALUES (2, 'authenticated');


--
-- Data for Name: product_attributes; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: product_classes; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: products_attributes; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO roles (roles_id, name, label) VALUES (1, 'anonymous', 'Anonymous Users');
INSERT INTO roles (roles_id, name, label) VALUES (2, 'authenticated', 'Authenticated Users');


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: settings; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: user_attributes; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: user_roles; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY addresses
    ADD CONSTRAINT addresses_pkey PRIMARY KEY (addresses_id);


--
-- Name: carts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY carts
    ADD CONSTRAINT carts_pkey PRIMARY KEY (carts_id);


--
-- Name: group_pricing_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY group_pricing
    ADD CONSTRAINT group_pricing_pkey PRIMARY KEY (group_pricing_id);


--
-- Name: inventory_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY inventory
    ADD CONSTRAINT inventory_pkey PRIMARY KEY (sku);


--
-- Name: media_displays_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY media_displays
    ADD CONSTRAINT media_displays_pkey PRIMARY KEY (media_displays_id);


--
-- Name: media_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY media
    ADD CONSTRAINT media_pkey PRIMARY KEY (media_id);


--
-- Name: media_products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY media_products
    ADD CONSTRAINT media_products_pkey PRIMARY KEY (media_products_id);


--
-- Name: media_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY media_types
    ADD CONSTRAINT media_types_pkey PRIMARY KEY (media_types_id);


--
-- Name: media_types_type_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY media_types
    ADD CONSTRAINT media_types_type_key UNIQUE (type);


--
-- Name: merchandising_attributes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY merchandising_attributes
    ADD CONSTRAINT merchandising_attributes_pkey PRIMARY KEY (merchandising_attributes_id);


--
-- Name: merchandising_products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY merchandising_products
    ADD CONSTRAINT merchandising_products_pkey PRIMARY KEY (merchandising_products_id);


--
-- Name: navigation_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY navigation
    ADD CONSTRAINT navigation_pkey PRIMARY KEY (navigation_id);


--
-- Name: navigation_products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY navigation_products
    ADD CONSTRAINT navigation_products_pkey PRIMARY KEY (sku, navigation_id);


--
-- Name: navigation_uri_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY navigation
    ADD CONSTRAINT navigation_uri_key UNIQUE (uri);


--
-- Name: orderlines_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY orderlines
    ADD CONSTRAINT orderlines_pkey PRIMARY KEY (orderlines_id);


--
-- Name: orderlines_shipping_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY orderlines_shipping
    ADD CONSTRAINT orderlines_shipping_pkey PRIMARY KEY (orderlines_id, addresses_id);


--
-- Name: orders_order_number_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY orders
    ADD CONSTRAINT orders_order_number_key UNIQUE (order_number);


--
-- Name: orders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (orders_id);


--
-- Name: payment_orders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY payment_orders
    ADD CONSTRAINT payment_orders_pkey PRIMARY KEY (payment_orders_id);


--
-- Name: product_attributes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY product_attributes
    ADD CONSTRAINT product_attributes_pkey PRIMARY KEY (product_attributes_id);


--
-- Name: product_classes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY product_classes
    ADD CONSTRAINT product_classes_pkey PRIMARY KEY (sku_class);


--
-- Name: products_attributes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY products_attributes
    ADD CONSTRAINT products_attributes_pkey PRIMARY KEY (sku, product_attributes_id);


--
-- Name: products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY products
    ADD CONSTRAINT products_pkey PRIMARY KEY (sku);


--
-- Name: roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (roles_id);


--
-- Name: sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (sessions_id);


--
-- Name: settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY settings
    ADD CONSTRAINT settings_pkey PRIMARY KEY (settings_id);


--
-- Name: user_attributes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_attributes
    ADD CONSTRAINT user_attributes_pkey PRIMARY KEY (user_attributes_id);


--
-- Name: user_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_roles
    ADD CONSTRAINT user_roles_pkey PRIMARY KEY (users_id, roles_id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (users_id);


--
-- Name: cart_products_cart_sku_ix; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX cart_products_cart_sku_ix ON cart_products USING btree (carts_id, sku);


--
-- Name: group_pricing_sku_ix; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX group_pricing_sku_ix ON group_pricing USING btree (sku);


--
-- Name: media_displays_sku_ix; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX media_displays_sku_ix ON media_displays USING btree (sku);


--
-- Name: media_products_sku_ix; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX media_products_sku_ix ON media_products USING btree (sku);


--
-- Name: orderlines_order_number_ix; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX orderlines_order_number_ix ON orderlines USING btree (order_number);


--
-- Name: payment_orders_order_number_ix; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX payment_orders_order_number_ix ON payment_orders USING btree (order_number);


--
-- Name: settings_scope_ix; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX settings_scope_ix ON settings USING btree (scope);


--
-- Name: user_attributes_users_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX user_attributes_users_id ON user_attributes USING btree (users_id);


--
-- Name: addresses_users_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY addresses
    ADD CONSTRAINT addresses_users_fk FOREIGN KEY (users_id) REFERENCES users(users_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cart_products_carts_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cart_products
    ADD CONSTRAINT cart_products_carts_fk FOREIGN KEY (carts_id) REFERENCES carts(carts_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cart_products_products_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cart_products
    ADD CONSTRAINT cart_products_products_fk FOREIGN KEY (sku) REFERENCES products(sku) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: carts_sessions_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY carts
    ADD CONSTRAINT carts_sessions_fk FOREIGN KEY (sessions_id) REFERENCES sessions(sessions_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: carts_users_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY carts
    ADD CONSTRAINT carts_users_fk FOREIGN KEY (users_id) REFERENCES users(users_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: group_pricing_products_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY group_pricing
    ADD CONSTRAINT group_pricing_products_fk FOREIGN KEY (sku) REFERENCES products(sku) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: group_pricing_roles_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY group_pricing
    ADD CONSTRAINT group_pricing_roles_fk FOREIGN KEY (roles_id) REFERENCES roles(roles_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: inventory_products_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY inventory
    ADD CONSTRAINT inventory_products_fk FOREIGN KEY (sku) REFERENCES products(sku) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: media_displays_media_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY media_displays
    ADD CONSTRAINT media_displays_media_fk FOREIGN KEY (media_id) REFERENCES media(media_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: media_displays_media_types_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY media_displays
    ADD CONSTRAINT media_displays_media_types_fk FOREIGN KEY (media_types_id) REFERENCES media_types(media_types_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: media_displays_products_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY media_displays
    ADD CONSTRAINT media_displays_products_fk FOREIGN KEY (sku) REFERENCES products(sku) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: media_products_media_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY media_products
    ADD CONSTRAINT media_products_media_fk FOREIGN KEY (media_id) REFERENCES media(media_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: media_products_products_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY media_products
    ADD CONSTRAINT media_products_products_fk FOREIGN KEY (sku) REFERENCES products(sku) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: merchandising_attributes_merchandising_products_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY merchandising_attributes
    ADD CONSTRAINT merchandising_attributes_merchandising_products_fk FOREIGN KEY (merchandising_products_id) REFERENCES merchandising_products(merchandising_products_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: merchandising_products_products_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY merchandising_products
    ADD CONSTRAINT merchandising_products_products_fk FOREIGN KEY (sku) REFERENCES products(sku) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: merchandising_products_related_products_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY merchandising_products
    ADD CONSTRAINT merchandising_products_related_products_fk FOREIGN KEY (sku_related) REFERENCES products(sku) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: navigation_products_navigation_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY navigation_products
    ADD CONSTRAINT navigation_products_navigation_fk FOREIGN KEY (navigation_id) REFERENCES navigation(navigation_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: navigation_products_products_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY navigation_products
    ADD CONSTRAINT navigation_products_products_fk FOREIGN KEY (sku) REFERENCES products(sku) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: orderlines_orders_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY orderlines
    ADD CONSTRAINT orderlines_orders_fk FOREIGN KEY (order_number) REFERENCES orders(order_number) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: orderlines_products_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY orderlines
    ADD CONSTRAINT orderlines_products_fk FOREIGN KEY (sku) REFERENCES products(sku) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: orderlines_shipping_addresses_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY orderlines_shipping
    ADD CONSTRAINT orderlines_shipping_addresses_fk FOREIGN KEY (addresses_id) REFERENCES addresses(addresses_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: orderlines_shipping_orderlines_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY orderlines_shipping
    ADD CONSTRAINT orderlines_shipping_orderlines_fk FOREIGN KEY (orderlines_id) REFERENCES orderlines(orderlines_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: orders_billing_address_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY orders
    ADD CONSTRAINT orders_billing_address_fk FOREIGN KEY (billing_addresses_id) REFERENCES addresses(addresses_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: orders_users_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY orders
    ADD CONSTRAINT orders_users_fk FOREIGN KEY (users_id) REFERENCES users(users_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: payment_orders_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY payment_orders
    ADD CONSTRAINT payment_orders_fk FOREIGN KEY (order_number) REFERENCES orders(order_number) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: payment_orders_sessions_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY payment_orders
    ADD CONSTRAINT payment_orders_sessions_fk FOREIGN KEY (sessions_id) REFERENCES sessions(sessions_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: permissions_roles_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY permissions
    ADD CONSTRAINT permissions_roles_fk FOREIGN KEY (roles_id) REFERENCES roles(roles_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: products_attributes_product_attributes_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY products_attributes
    ADD CONSTRAINT products_attributes_product_attributes_fk FOREIGN KEY (product_attributes_id) REFERENCES product_attributes(product_attributes_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: products_attributes_products_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY products_attributes
    ADD CONSTRAINT products_attributes_products_fk FOREIGN KEY (sku) REFERENCES products(sku) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: products_product_classes_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY products
    ADD CONSTRAINT products_product_classes_fk FOREIGN KEY (sku_class) REFERENCES product_classes(sku_class) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: user_attributes_users_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_attributes
    ADD CONSTRAINT user_attributes_users_fk FOREIGN KEY (users_id) REFERENCES users(users_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: user_roles_roles_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_roles
    ADD CONSTRAINT user_roles_roles_fk FOREIGN KEY (roles_id) REFERENCES roles(roles_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: user_roles_users_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_roles
    ADD CONSTRAINT user_roles_users_fk FOREIGN KEY (users_id) REFERENCES users(users_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

