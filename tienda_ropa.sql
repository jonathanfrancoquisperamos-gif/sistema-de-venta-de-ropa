--
-- PostgreSQL database dump
--

\restrict Y79kGAiKrq2CJPhGI6v8hYE6yGf2A17KqkKlSUPWDETqjwiYW4DWJSb3PLKSdBs

-- Dumped from database version 18.3
-- Dumped by pg_dump version 18.3

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: cliente; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cliente (
    idcliente integer NOT NULL,
    nombre character varying(50) NOT NULL,
    apellido character varying(50) NOT NULL,
    direccion character varying(100),
    telefono character varying(20),
    email character varying(50)
);


ALTER TABLE public.cliente OWNER TO postgres;

--
-- Name: cliente_idcliente_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cliente_idcliente_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cliente_idcliente_seq OWNER TO postgres;

--
-- Name: cliente_idcliente_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cliente_idcliente_seq OWNED BY public.cliente.idcliente;


--
-- Name: detallepedido; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.detallepedido (
    iddetalle integer NOT NULL,
    idpedido integer,
    idvariante integer,
    cantidad integer NOT NULL,
    precioventa numeric(10,2) NOT NULL
);


ALTER TABLE public.detallepedido OWNER TO postgres;

--
-- Name: detallepedido_iddetalle_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.detallepedido_iddetalle_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.detallepedido_iddetalle_seq OWNER TO postgres;

--
-- Name: detallepedido_iddetalle_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.detallepedido_iddetalle_seq OWNED BY public.detallepedido.iddetalle;


--
-- Name: inventariosucursal; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inventariosucursal (
    idinventario integer NOT NULL,
    idsucursal integer,
    idvariante integer,
    stockdisponible integer NOT NULL
);


ALTER TABLE public.inventariosucursal OWNER TO postgres;

--
-- Name: inventariosucursal_idinventario_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.inventariosucursal_idinventario_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.inventariosucursal_idinventario_seq OWNER TO postgres;

--
-- Name: inventariosucursal_idinventario_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.inventariosucursal_idinventario_seq OWNED BY public.inventariosucursal.idinventario;


--
-- Name: pago; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pago (
    idpago integer NOT NULL,
    idpedido integer,
    fechapago date NOT NULL,
    monto numeric(10,2) NOT NULL,
    metodopago character varying(20) NOT NULL
);


ALTER TABLE public.pago OWNER TO postgres;

--
-- Name: pago_idpago_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pago_idpago_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pago_idpago_seq OWNER TO postgres;

--
-- Name: pago_idpago_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pago_idpago_seq OWNED BY public.pago.idpago;


--
-- Name: pedido; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pedido (
    idpedido integer NOT NULL,
    idcliente integer,
    idvendedor integer,
    fechapedido date NOT NULL,
    estadopedido character varying(20) DEFAULT 'Pendiente'::character varying
);


ALTER TABLE public.pedido OWNER TO postgres;

--
-- Name: pedido_idpedido_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pedido_idpedido_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pedido_idpedido_seq OWNER TO postgres;

--
-- Name: pedido_idpedido_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pedido_idpedido_seq OWNED BY public.pedido.idpedido;


--
-- Name: producto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.producto (
    idproducto integer NOT NULL,
    nombre character varying(100) NOT NULL,
    categoria character varying(50),
    marca character varying(50),
    preciobase numeric(10,2) NOT NULL
);


ALTER TABLE public.producto OWNER TO postgres;

--
-- Name: producto_idproducto_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.producto_idproducto_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.producto_idproducto_seq OWNER TO postgres;

--
-- Name: producto_idproducto_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.producto_idproducto_seq OWNED BY public.producto.idproducto;


--
-- Name: productoproveedor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.productoproveedor (
    idproducto integer NOT NULL,
    idproveedor integer NOT NULL
);


ALTER TABLE public.productoproveedor OWNER TO postgres;

--
-- Name: proveedor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.proveedor (
    idproveedor integer NOT NULL,
    nombre character varying(100) NOT NULL,
    direccion character varying(100),
    telefono character varying(20),
    email character varying(50)
);


ALTER TABLE public.proveedor OWNER TO postgres;

--
-- Name: proveedor_idproveedor_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.proveedor_idproveedor_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.proveedor_idproveedor_seq OWNER TO postgres;

--
-- Name: proveedor_idproveedor_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.proveedor_idproveedor_seq OWNED BY public.proveedor.idproveedor;


--
-- Name: sucursal; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sucursal (
    idsucursal integer NOT NULL,
    nombre character varying(50),
    direccion character varying(100),
    ciudad character varying(50)
);


ALTER TABLE public.sucursal OWNER TO postgres;

--
-- Name: sucursal_idsucursal_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sucursal_idsucursal_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.sucursal_idsucursal_seq OWNER TO postgres;

--
-- Name: sucursal_idsucursal_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sucursal_idsucursal_seq OWNED BY public.sucursal.idsucursal;


--
-- Name: varianteproducto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.varianteproducto (
    idvariante integer NOT NULL,
    idproducto integer,
    talla character varying(10) NOT NULL,
    color character varying(30) NOT NULL,
    stockactual integer NOT NULL
);


ALTER TABLE public.varianteproducto OWNER TO postgres;

--
-- Name: varianteproducto_idvariante_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.varianteproducto_idvariante_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.varianteproducto_idvariante_seq OWNER TO postgres;

--
-- Name: varianteproducto_idvariante_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.varianteproducto_idvariante_seq OWNED BY public.varianteproducto.idvariante;


--
-- Name: vendedor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vendedor (
    idvendedor integer NOT NULL,
    nombre character varying(50) NOT NULL,
    apellido character varying(50) NOT NULL,
    email character varying(50),
    telefono character varying(20),
    rol character varying(30)
);


ALTER TABLE public.vendedor OWNER TO postgres;

--
-- Name: vendedor_idvendedor_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.vendedor_idvendedor_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.vendedor_idvendedor_seq OWNER TO postgres;

--
-- Name: vendedor_idvendedor_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.vendedor_idvendedor_seq OWNED BY public.vendedor.idvendedor;


--
-- Name: cliente idcliente; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cliente ALTER COLUMN idcliente SET DEFAULT nextval('public.cliente_idcliente_seq'::regclass);


--
-- Name: detallepedido iddetalle; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detallepedido ALTER COLUMN iddetalle SET DEFAULT nextval('public.detallepedido_iddetalle_seq'::regclass);


--
-- Name: inventariosucursal idinventario; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventariosucursal ALTER COLUMN idinventario SET DEFAULT nextval('public.inventariosucursal_idinventario_seq'::regclass);


--
-- Name: pago idpago; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pago ALTER COLUMN idpago SET DEFAULT nextval('public.pago_idpago_seq'::regclass);


--
-- Name: pedido idpedido; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido ALTER COLUMN idpedido SET DEFAULT nextval('public.pedido_idpedido_seq'::regclass);


--
-- Name: producto idproducto; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.producto ALTER COLUMN idproducto SET DEFAULT nextval('public.producto_idproducto_seq'::regclass);


--
-- Name: proveedor idproveedor; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.proveedor ALTER COLUMN idproveedor SET DEFAULT nextval('public.proveedor_idproveedor_seq'::regclass);


--
-- Name: sucursal idsucursal; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sucursal ALTER COLUMN idsucursal SET DEFAULT nextval('public.sucursal_idsucursal_seq'::regclass);


--
-- Name: varianteproducto idvariante; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.varianteproducto ALTER COLUMN idvariante SET DEFAULT nextval('public.varianteproducto_idvariante_seq'::regclass);


--
-- Name: vendedor idvendedor; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vendedor ALTER COLUMN idvendedor SET DEFAULT nextval('public.vendedor_idvendedor_seq'::regclass);


--
-- Data for Name: cliente; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cliente (idcliente, nombre, apellido, direccion, telefono, email) FROM stdin;
1	María	González	Av. Arce 123	78945612	maria@mail.com
2	Carlos	Pérez	Calle Comercio 45	76543210	carlos@mail.com
3	Ana	Ramírez	Av. Busch 321	71234567	ana@mail.com
4	José	López	Av. Saavedra 200	70123456	jose@mail.com
5	Lucía	Torres	Calle Illampu 50	70987654	lucia@mail.com
6	Miguel	Flores	Av. América 300	76543222	miguel@mail.com
7	Paola	Suárez	Calle Murillo 80	70112233	paola@mail.com
8	Javier	Mendoza	Av. Camacho 150	71234511	javier@mail.com
9	Andrea	Vargas	Calle 21 Calacoto	78945699	andrea@mail.com
10	Diego	Castro	Av. Montes 400	76543255	diego@mail.com
\.


--
-- Data for Name: detallepedido; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.detallepedido (iddetalle, idpedido, idvariante, cantidad, precioventa) FROM stdin;
1	1	1	2	240.00
2	1	3	1	180.00
3	2	5	1	250.00
4	3	2	1	120.00
5	4	4	2	360.00
6	5	6	1	250.00
7	6	7	1	300.00
8	7	8	2	200.00
9	8	9	1	220.00
10	9	10	1	200.00
\.


--
-- Data for Name: inventariosucursal; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inventariosucursal (idinventario, idsucursal, idvariante, stockdisponible) FROM stdin;
1	1	1	10
2	1	2	8
3	2	3	15
4	2	4	12
5	3	5	5
6	4	6	3
7	5	7	7
8	6	8	9
9	7	9	6
10	8	10	4
\.


--
-- Data for Name: pago; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pago (idpago, idpedido, fechapago, monto, metodopago) FROM stdin;
1	1	2026-05-01	420.00	Tarjeta
2	2	2026-05-02	250.00	Efectivo
3	3	2026-05-03	120.00	Transferencia
4	4	2026-05-04	360.00	Tarjeta
5	5	2026-05-05	250.00	Efectivo
6	6	2026-05-06	300.00	Transferencia
7	7	2026-05-07	200.00	Tarjeta
8	8	2026-05-08	220.00	Efectivo
9	9	2026-05-09	200.00	Transferencia
10	10	2026-05-10	150.00	Tarjeta
\.


--
-- Data for Name: pedido; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pedido (idpedido, idcliente, idvendedor, fechapedido, estadopedido) FROM stdin;
1	1	1	2026-05-01	Pendiente
2	2	2	2026-05-02	Entregado
3	3	3	2026-05-03	Pendiente
4	4	4	2026-05-04	Cancelado
5	5	5	2026-05-05	Entregado
6	6	6	2026-05-06	Pendiente
7	7	7	2026-05-07	Pendiente
8	8	8	2026-05-08	Entregado
9	9	9	2026-05-09	Pendiente
10	10	10	2026-05-10	Pendiente
\.


--
-- Data for Name: producto; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.producto (idproducto, nombre, categoria, marca, preciobase) FROM stdin;
1	Camisa Formal	Camisa	Andinos	120.00
2	Pantalón Jeans	Pantalón	ModaGlobal	180.00
3	Vestido Casual	Vestido	Andinos	250.00
4	Chaqueta Deportiva	Chaqueta	FashionWorld	300.00
5	Falda Elegante	Falda	Elegancia	200.00
6	Polera Básica	Polera	JuvenilModa	80.00
7	Abrigo Invierno	Abrigo	PremiumTextiles	400.00
8	Camisa Manga Corta	Camisa	ClassicWear	100.00
9	Pantalón Formal	Pantalón	EstiloUrbano	220.00
10	Vestido Fiesta	Vestido	TrendyClothes	350.00
\.


--
-- Data for Name: productoproveedor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.productoproveedor (idproducto, idproveedor) FROM stdin;
\.


--
-- Data for Name: proveedor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.proveedor (idproveedor, nombre, direccion, telefono, email) FROM stdin;
1	Textiles Andinos	Av. Montes 200	76543211	andinos@mail.com
2	Moda Global	Calle Murillo 50	70112233	moda@mail.com
3	Fashion World	Av. Busch 123	78945677	fashion@mail.com
4	Ropa Latina	Calle Comercio 90	76543244	latina@mail.com
5	Estilo Urbano	Av. América 400	70123488	urbano@mail.com
6	Elegancia SRL	Calle Illampu 70	70987666	elegancia@mail.com
7	Trendy Clothes	Av. Camacho 200	71234599	trendy@mail.com
8	Classic Wear	Calle 21 Calacoto	78945633	classic@mail.com
9	Juvenil Moda	Av. Saavedra 150	76543277	juvenil@mail.com
10	Premium Textiles	Av. Arce 300	70112255	premium@mail.com
\.


--
-- Data for Name: sucursal; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sucursal (idsucursal, nombre, direccion, ciudad) FROM stdin;
1	Sucursal Central	Av. Camacho 100	La Paz
2	Sucursal Sur	Calle 21 Calacoto	La Paz
3	Sucursal Norte	Av. Montes 300	La Paz
4	Sucursal El Alto	Av. 6 de Marzo	El Alto
5	Sucursal Cochabamba	Av. América 200	Cochabamba
6	Sucursal Santa Cruz	Av. Cristo Redentor	Santa Cruz
7	Sucursal Tarija	Av. Las Américas	Tarija
8	Sucursal Oruro	Av. Busch 400	Oruro
9	Sucursal Potosí	Av. Litoral	Potosí
10	Sucursal Sucre	Av. Arce 500	Sucre
\.


--
-- Data for Name: varianteproducto; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.varianteproducto (idvariante, idproducto, talla, color, stockactual) FROM stdin;
1	1	M	Blanco	20
2	1	L	Celeste	15
3	2	32	Azul	30
4	2	34	Negro	25
5	3	S	Rojo	10
6	3	M	Verde	8
7	4	M	Negro	12
8	4	L	Gris	10
9	5	S	Azul	14
10	5	M	Negro	9
\.


--
-- Data for Name: vendedor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vendedor (idvendedor, nombre, apellido, email, telefono, rol) FROM stdin;
1	Luis	Fernández	luis@tienda.com	70123456	Cajero
2	Sofía	Martínez	sofia@tienda.com	70987654	Vendedor
3	Pedro	Gutiérrez	pedro@tienda.com	71234567	Supervisor
4	Carla	Rojas	carla@tienda.com	76543210	Vendedor
5	Hugo	Salinas	hugo@tienda.com	70112233	Cajero
6	Marta	Quispe	marta@tienda.com	78945612	Vendedor
7	Daniel	Ortiz	daniel@tienda.com	76543222	Supervisor
8	Elena	Rivera	elena@tienda.com	70987655	Vendedor
9	Raúl	Aguilar	raul@tienda.com	70123457	Cajero
10	Patricia	Morales	patricia@tienda.com	71234512	Vendedor
\.


--
-- Name: cliente_idcliente_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cliente_idcliente_seq', 10, true);


--
-- Name: detallepedido_iddetalle_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.detallepedido_iddetalle_seq', 10, true);


--
-- Name: inventariosucursal_idinventario_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.inventariosucursal_idinventario_seq', 10, true);


--
-- Name: pago_idpago_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pago_idpago_seq', 10, true);


--
-- Name: pedido_idpedido_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pedido_idpedido_seq', 10, true);


--
-- Name: producto_idproducto_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.producto_idproducto_seq', 10, true);


--
-- Name: proveedor_idproveedor_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.proveedor_idproveedor_seq', 10, true);


--
-- Name: sucursal_idsucursal_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sucursal_idsucursal_seq', 10, true);


--
-- Name: varianteproducto_idvariante_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.varianteproducto_idvariante_seq', 10, true);


--
-- Name: vendedor_idvendedor_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.vendedor_idvendedor_seq', 10, true);


--
-- Name: cliente cliente_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_email_key UNIQUE (email);


--
-- Name: cliente cliente_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_pkey PRIMARY KEY (idcliente);


--
-- Name: detallepedido detallepedido_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detallepedido
    ADD CONSTRAINT detallepedido_pkey PRIMARY KEY (iddetalle);


--
-- Name: inventariosucursal inventariosucursal_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventariosucursal
    ADD CONSTRAINT inventariosucursal_pkey PRIMARY KEY (idinventario);


--
-- Name: pago pago_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pago
    ADD CONSTRAINT pago_pkey PRIMARY KEY (idpago);


--
-- Name: pedido pedido_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido
    ADD CONSTRAINT pedido_pkey PRIMARY KEY (idpedido);


--
-- Name: producto producto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.producto
    ADD CONSTRAINT producto_pkey PRIMARY KEY (idproducto);


--
-- Name: productoproveedor productoproveedor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.productoproveedor
    ADD CONSTRAINT productoproveedor_pkey PRIMARY KEY (idproducto, idproveedor);


--
-- Name: proveedor proveedor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.proveedor
    ADD CONSTRAINT proveedor_pkey PRIMARY KEY (idproveedor);


--
-- Name: sucursal sucursal_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sucursal
    ADD CONSTRAINT sucursal_pkey PRIMARY KEY (idsucursal);


--
-- Name: varianteproducto varianteproducto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.varianteproducto
    ADD CONSTRAINT varianteproducto_pkey PRIMARY KEY (idvariante);


--
-- Name: vendedor vendedor_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vendedor
    ADD CONSTRAINT vendedor_email_key UNIQUE (email);


--
-- Name: vendedor vendedor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vendedor
    ADD CONSTRAINT vendedor_pkey PRIMARY KEY (idvendedor);


--
-- Name: detallepedido detallepedido_idpedido_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detallepedido
    ADD CONSTRAINT detallepedido_idpedido_fkey FOREIGN KEY (idpedido) REFERENCES public.pedido(idpedido);


--
-- Name: detallepedido detallepedido_idvariante_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detallepedido
    ADD CONSTRAINT detallepedido_idvariante_fkey FOREIGN KEY (idvariante) REFERENCES public.varianteproducto(idvariante);


--
-- Name: inventariosucursal inventariosucursal_idsucursal_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventariosucursal
    ADD CONSTRAINT inventariosucursal_idsucursal_fkey FOREIGN KEY (idsucursal) REFERENCES public.sucursal(idsucursal);


--
-- Name: inventariosucursal inventariosucursal_idvariante_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventariosucursal
    ADD CONSTRAINT inventariosucursal_idvariante_fkey FOREIGN KEY (idvariante) REFERENCES public.varianteproducto(idvariante);


--
-- Name: pago pago_idpedido_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pago
    ADD CONSTRAINT pago_idpedido_fkey FOREIGN KEY (idpedido) REFERENCES public.pedido(idpedido);


--
-- Name: pedido pedido_idcliente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido
    ADD CONSTRAINT pedido_idcliente_fkey FOREIGN KEY (idcliente) REFERENCES public.cliente(idcliente);


--
-- Name: pedido pedido_idvendedor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido
    ADD CONSTRAINT pedido_idvendedor_fkey FOREIGN KEY (idvendedor) REFERENCES public.vendedor(idvendedor);


--
-- Name: productoproveedor productoproveedor_idproducto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.productoproveedor
    ADD CONSTRAINT productoproveedor_idproducto_fkey FOREIGN KEY (idproducto) REFERENCES public.producto(idproducto);


--
-- Name: productoproveedor productoproveedor_idproveedor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.productoproveedor
    ADD CONSTRAINT productoproveedor_idproveedor_fkey FOREIGN KEY (idproveedor) REFERENCES public.proveedor(idproveedor);


--
-- Name: varianteproducto varianteproducto_idproducto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.varianteproducto
    ADD CONSTRAINT varianteproducto_idproducto_fkey FOREIGN KEY (idproducto) REFERENCES public.producto(idproducto);


--
-- PostgreSQL database dump complete
--

\unrestrict Y79kGAiKrq2CJPhGI6v8hYE6yGf2A17KqkKlSUPWDETqjwiYW4DWJSb3PLKSdBs

