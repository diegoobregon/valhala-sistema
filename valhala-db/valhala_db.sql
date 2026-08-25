--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4
-- Dumped by pg_dump version 16.4

-- Started on 2026-08-24 17:08:59

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 2 (class 3079 OID 16562)
-- Name: btree_gist; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS btree_gist WITH SCHEMA public;


--
-- TOC entry 5454 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION btree_gist; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION btree_gist IS 'support for indexing common datatypes in GiST';


--
-- TOC entry 3 (class 3079 OID 17512)
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- TOC entry 5455 (class 0 OID 0)
-- Dependencies: 3
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 226 (class 1259 OID 17273)
-- Name: categorias_linea_amarrilla; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categorias_linea_amarrilla (
    id_categoria integer NOT NULL,
    nombre_categoria character varying(100) NOT NULL,
    descripcion text
);


ALTER TABLE public.categorias_linea_amarrilla OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 17272)
-- Name: categorias_linea_amarrilla_id_categoria_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.categorias_linea_amarrilla_id_categoria_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.categorias_linea_amarrilla_id_categoria_seq OWNER TO postgres;

--
-- TOC entry 5456 (class 0 OID 0)
-- Dependencies: 225
-- Name: categorias_linea_amarrilla_id_categoria_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.categorias_linea_amarrilla_id_categoria_seq OWNED BY public.categorias_linea_amarrilla.id_categoria;


--
-- TOC entry 240 (class 1259 OID 17387)
-- Name: check_in_retornos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.check_in_retornos (
    id_retorno integer NOT NULL,
    id_salida integer NOT NULL,
    id_usuario_mecanico integer NOT NULL,
    fecha_recepcion timestamp without time zone DEFAULT now() NOT NULL,
    horometro_final numeric(12,2) NOT NULL,
    estado_devolucion character varying(20) DEFAULT 'CONFORME'::character varying NOT NULL,
    CONSTRAINT check_in_retornos_horometro_final_check CHECK ((horometro_final >= (0)::numeric))
);


ALTER TABLE public.check_in_retornos OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 17386)
-- Name: check_in_retornos_id_retorno_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.check_in_retornos_id_retorno_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.check_in_retornos_id_retorno_seq OWNER TO postgres;

--
-- TOC entry 5457 (class 0 OID 0)
-- Dependencies: 239
-- Name: check_in_retornos_id_retorno_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.check_in_retornos_id_retorno_seq OWNED BY public.check_in_retornos.id_retorno;


--
-- TOC entry 238 (class 1259 OID 17366)
-- Name: check_out_salidas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.check_out_salidas (
    id_salida integer NOT NULL,
    id_reserva integer NOT NULL,
    id_usuario_mecanico integer NOT NULL,
    fecha_despacho timestamp without time zone DEFAULT now() NOT NULL,
    horometro_inicial numeric(12,2) NOT NULL,
    CONSTRAINT check_out_salidas_horometro_inicial_check CHECK ((horometro_inicial >= (0)::numeric))
);


ALTER TABLE public.check_out_salidas OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 17365)
-- Name: check_out_salidas_id_salida_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.check_out_salidas_id_salida_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.check_out_salidas_id_salida_seq OWNER TO postgres;

--
-- TOC entry 5458 (class 0 OID 0)
-- Dependencies: 237
-- Name: check_out_salidas_id_salida_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.check_out_salidas_id_salida_seq OWNED BY public.check_out_salidas.id_salida;


--
-- TOC entry 222 (class 1259 OID 17241)
-- Name: clientes_corporativos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.clientes_corporativos (
    id_cliente integer NOT NULL,
    ruc character varying(11) NOT NULL,
    razon_social character varying(150) NOT NULL,
    direccion_fiscal character varying(255),
    telefono character varying(20),
    email_contacto character varying(120)
);


ALTER TABLE public.clientes_corporativos OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 17240)
-- Name: clientes_corporativos_id_cliente_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.clientes_corporativos_id_cliente_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.clientes_corporativos_id_cliente_seq OWNER TO postgres;

--
-- TOC entry 5459 (class 0 OID 0)
-- Dependencies: 221
-- Name: clientes_corporativos_id_cliente_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.clientes_corporativos_id_cliente_seq OWNED BY public.clientes_corporativos.id_cliente;


--
-- TOC entry 224 (class 1259 OID 17252)
-- Name: contratos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contratos (
    id_contrato integer NOT NULL,
    id_cliente integer NOT NULL,
    id_usuario_creador integer NOT NULL,
    fecha_emision date DEFAULT CURRENT_DATE NOT NULL,
    fecha_inicio date NOT NULL,
    fecha_fin date NOT NULL,
    estado_contrato character varying(20) DEFAULT 'BORRADOR'::character varying NOT NULL,
    CONSTRAINT contratos_check CHECK ((fecha_fin >= fecha_inicio)),
    CONSTRAINT contratos_estado_contrato_check CHECK (((estado_contrato)::text = ANY ((ARRAY['BORRADOR'::character varying, 'ACTIVO'::character varying, 'CONCLUIDO'::character varying, 'ANULADO'::character varying])::text[])))
);


ALTER TABLE public.contratos OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 17251)
-- Name: contratos_id_contrato_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.contratos_id_contrato_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.contratos_id_contrato_seq OWNER TO postgres;

--
-- TOC entry 5460 (class 0 OID 0)
-- Dependencies: 223
-- Name: contratos_id_contrato_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.contratos_id_contrato_seq OWNED BY public.contratos.id_contrato;


--
-- TOC entry 230 (class 1259 OID 17299)
-- Name: documentos_legales; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.documentos_legales (
    id_documento integer NOT NULL,
    id_equipo integer NOT NULL,
    tipo_poliza character varying(50) NOT NULL,
    numero_poliza character varying(50) NOT NULL,
    fecha_vencimiento date NOT NULL,
    estado_legal character varying(20) DEFAULT 'VIGENTE'::character varying NOT NULL,
    CONSTRAINT documentos_legales_estado_legal_check CHECK (((estado_legal)::text = ANY ((ARRAY['VIGENTE'::character varying, 'VENCIDO'::character varying, 'EN_TRAMITE'::character varying])::text[])))
);


ALTER TABLE public.documentos_legales OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 17298)
-- Name: documentos_legales_id_documento_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.documentos_legales_id_documento_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.documentos_legales_id_documento_seq OWNER TO postgres;

--
-- TOC entry 5461 (class 0 OID 0)
-- Dependencies: 229
-- Name: documentos_legales_id_documento_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.documentos_legales_id_documento_seq OWNED BY public.documentos_legales.id_documento;


--
-- TOC entry 228 (class 1259 OID 17282)
-- Name: equipos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.equipos (
    id_equipo integer NOT NULL,
    id_categoria integer NOT NULL,
    codigo_patrimonial character varying(50) NOT NULL,
    marca character varying(50) NOT NULL,
    modelo character varying(50) NOT NULL,
    anio_fabricacion integer,
    horometro_acumulado numeric(12,2) DEFAULT 0 NOT NULL,
    CONSTRAINT equipos_anio_fabricacion_check CHECK (((anio_fabricacion >= 1980) AND (anio_fabricacion <= 2026))),
    CONSTRAINT equipos_horometro_acumulado_check CHECK ((horometro_acumulado >= (0)::numeric))
);


ALTER TABLE public.equipos OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 17281)
-- Name: equipos_id_equipo_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.equipos_id_equipo_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.equipos_id_equipo_seq OWNER TO postgres;

--
-- TOC entry 5462 (class 0 OID 0)
-- Dependencies: 227
-- Name: equipos_id_equipo_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.equipos_id_equipo_seq OWNED BY public.equipos.id_equipo;


--
-- TOC entry 232 (class 1259 OID 17313)
-- Name: estado_actual_equipos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.estado_actual_equipos (
    id_estado integer NOT NULL,
    id_equipo integer NOT NULL,
    estatus_operativo character varying(30) DEFAULT 'OPERATIVO'::character varying NOT NULL,
    ubicacion_geom point,
    CONSTRAINT estado_actual_equipos_estatus_operativo_check CHECK (((estatus_operativo)::text = ANY ((ARRAY['OPERATIVO'::character varying, 'ALQUILADO'::character varying, 'MANTENIMIENTO'::character varying, 'FUERA_DE_SERVICIO'::character varying])::text[])))
);


ALTER TABLE public.estado_actual_equipos OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 17312)
-- Name: estado_actual_equipos_id_estado_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.estado_actual_equipos_id_estado_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.estado_actual_equipos_id_estado_seq OWNER TO postgres;

--
-- TOC entry 5463 (class 0 OID 0)
-- Dependencies: 231
-- Name: estado_actual_equipos_id_estado_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.estado_actual_equipos_id_estado_seq OWNED BY public.estado_actual_equipos.id_estado;


--
-- TOC entry 242 (class 1259 OID 17409)
-- Name: inspecciones_pwa; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inspecciones_pwa (
    id_inspeccion integer NOT NULL,
    id_salida integer,
    id_retorno integer,
    tipo_registro character varying(20) NOT NULL,
    evidencias_fotos jsonb DEFAULT '[]'::jsonb NOT NULL,
    observaciones text,
    CONSTRAINT inspecciones_pwa_check CHECK (((id_salida IS NOT NULL) OR (id_retorno IS NOT NULL))),
    CONSTRAINT inspecciones_pwa_tipo_registro_check CHECK (((tipo_registro)::text = ANY ((ARRAY['CHECK_OUT'::character varying, 'CHECK_IN'::character varying, 'INCIDENCIA'::character varying])::text[])))
);


ALTER TABLE public.inspecciones_pwa OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 17408)
-- Name: inspecciones_pwa_id_inspeccion_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.inspecciones_pwa_id_inspeccion_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.inspecciones_pwa_id_inspeccion_seq OWNER TO postgres;

--
-- TOC entry 5464 (class 0 OID 0)
-- Dependencies: 241
-- Name: inspecciones_pwa_id_inspeccion_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.inspecciones_pwa_id_inspeccion_seq OWNED BY public.inspecciones_pwa.id_inspeccion;


--
-- TOC entry 234 (class 1259 OID 17329)
-- Name: items_contrato; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.items_contrato (
    id_item integer NOT NULL,
    id_contrato integer NOT NULL,
    id_equipo integer NOT NULL,
    tarifa_por_hora numeric(10,2) NOT NULL,
    horas_minimas_garantizadas numeric(8,2) DEFAULT 0 NOT NULL,
    costo_flete numeric(10,2) DEFAULT 0 NOT NULL,
    CONSTRAINT items_contrato_tarifa_por_hora_check CHECK ((tarifa_por_hora > (0)::numeric))
);


ALTER TABLE public.items_contrato OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 17328)
-- Name: items_contrato_id_item_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.items_contrato_id_item_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.items_contrato_id_item_seq OWNER TO postgres;

--
-- TOC entry 5465 (class 0 OID 0)
-- Dependencies: 233
-- Name: items_contrato_id_item_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.items_contrato_id_item_seq OWNED BY public.items_contrato.id_item;


--
-- TOC entry 244 (class 1259 OID 17431)
-- Name: liquidaciones_financieras; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.liquidaciones_financieras (
    id_liquidacion integer NOT NULL,
    id_retorno integer NOT NULL,
    horas_base_consumidas numeric(10,2) NOT NULL,
    horas_extra_calculadas numeric(10,2) DEFAULT 0 NOT NULL,
    subtotal numeric(12,2) NOT NULL,
    igv numeric(12,2) NOT NULL,
    total_facturar numeric(12,2) NOT NULL,
    estado_cobro character varying(20) DEFAULT 'PENDIENTE'::character varying NOT NULL,
    CONSTRAINT liquidaciones_financieras_estado_cobro_check CHECK (((estado_cobro)::text = ANY ((ARRAY['PENDIENTE'::character varying, 'FACTURADO'::character varying, 'PAGADO'::character varying])::text[]))),
    CONSTRAINT liquidaciones_financieras_horas_base_consumidas_check CHECK ((horas_base_consumidas >= (0)::numeric))
);


ALTER TABLE public.liquidaciones_financieras OWNER TO postgres;

--
-- TOC entry 243 (class 1259 OID 17430)
-- Name: liquidaciones_financieras_id_liquidacion_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.liquidaciones_financieras_id_liquidacion_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.liquidaciones_financieras_id_liquidacion_seq OWNER TO postgres;

--
-- TOC entry 5466 (class 0 OID 0)
-- Dependencies: 243
-- Name: liquidaciones_financieras_id_liquidacion_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.liquidaciones_financieras_id_liquidacion_seq OWNED BY public.liquidaciones_financieras.id_liquidacion;


--
-- TOC entry 246 (class 1259 OID 17449)
-- Name: mantenimientos_taller; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mantenimientos_taller (
    id_mantenimiento integer NOT NULL,
    id_equipo integer NOT NULL,
    id_usuario_mecanico integer NOT NULL,
    tipo_mantenimiento character varying(50) NOT NULL,
    horometro_ejecucion numeric(12,2) NOT NULL,
    costo_reparacion numeric(12,2) DEFAULT 0 NOT NULL
);


ALTER TABLE public.mantenimientos_taller OWNER TO postgres;

--
-- TOC entry 245 (class 1259 OID 17448)
-- Name: mantenimientos_taller_id_mantenimiento_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.mantenimientos_taller_id_mantenimiento_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.mantenimientos_taller_id_mantenimiento_seq OWNER TO postgres;

--
-- TOC entry 5467 (class 0 OID 0)
-- Dependencies: 245
-- Name: mantenimientos_taller_id_mantenimiento_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.mantenimientos_taller_id_mantenimiento_seq OWNED BY public.mantenimientos_taller.id_mantenimiento;


--
-- TOC entry 236 (class 1259 OID 17349)
-- Name: reservas_gantt; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reservas_gantt (
    id_reserva integer NOT NULL,
    id_item_contrato integer NOT NULL,
    fecha_inicio_reserva date NOT NULL,
    fecha_fin_reserva date NOT NULL,
    estado_reserva character varying(20) DEFAULT 'PENDIENTE'::character varying NOT NULL,
    CONSTRAINT reservas_gantt_check CHECK ((fecha_fin_reserva >= fecha_inicio_reserva)),
    CONSTRAINT reservas_gantt_estado_reserva_check CHECK (((estado_reserva)::text = ANY ((ARRAY['PENDIENTE'::character varying, 'CONFIRMADA'::character varying, 'ANULADA'::character varying])::text[])))
);


ALTER TABLE public.reservas_gantt OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 17348)
-- Name: reservas_gantt_id_reserva_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.reservas_gantt_id_reserva_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.reservas_gantt_id_reserva_seq OWNER TO postgres;

--
-- TOC entry 5468 (class 0 OID 0)
-- Dependencies: 235
-- Name: reservas_gantt_id_reserva_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.reservas_gantt_id_reserva_seq OWNED BY public.reservas_gantt.id_reserva;


--
-- TOC entry 218 (class 1259 OID 17213)
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    id_rol integer NOT NULL,
    nombre_rol character varying(50) NOT NULL,
    descripcion character varying(255)
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 17212)
-- Name: roles_id_rol_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.roles_id_rol_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.roles_id_rol_seq OWNER TO postgres;

--
-- TOC entry 5469 (class 0 OID 0)
-- Dependencies: 217
-- Name: roles_id_rol_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.roles_id_rol_seq OWNED BY public.roles.id_rol;


--
-- TOC entry 248 (class 1259 OID 17467)
-- Name: telemetria_iot_particionada; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.telemetria_iot_particionada (
    id_telemetria bigint NOT NULL,
    id_equipo integer NOT NULL,
    fecha_hora_registro timestamp without time zone NOT NULL,
    coordenadas_gps point,
    horometro_sensor_iot numeric(12,2),
    voltaje_bateria numeric(5,2)
)
PARTITION BY RANGE (fecha_hora_registro);


ALTER TABLE public.telemetria_iot_particionada OWNER TO postgres;

--
-- TOC entry 247 (class 1259 OID 17466)
-- Name: telemetria_iot_particionada_id_telemetria_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.telemetria_iot_particionada_id_telemetria_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.telemetria_iot_particionada_id_telemetria_seq OWNER TO postgres;

--
-- TOC entry 5470 (class 0 OID 0)
-- Dependencies: 247
-- Name: telemetria_iot_particionada_id_telemetria_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.telemetria_iot_particionada_id_telemetria_seq OWNED BY public.telemetria_iot_particionada.id_telemetria;


--
-- TOC entry 249 (class 1259 OID 17478)
-- Name: telemetria_y2026m07; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.telemetria_y2026m07 (
    id_telemetria bigint DEFAULT nextval('public.telemetria_iot_particionada_id_telemetria_seq'::regclass) NOT NULL,
    id_equipo integer NOT NULL,
    fecha_hora_registro timestamp without time zone NOT NULL,
    coordenadas_gps point,
    horometro_sensor_iot numeric(12,2),
    voltaje_bateria numeric(5,2)
);


ALTER TABLE public.telemetria_y2026m07 OWNER TO postgres;

--
-- TOC entry 250 (class 1259 OID 17487)
-- Name: telemetria_y2026m08; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.telemetria_y2026m08 (
    id_telemetria bigint DEFAULT nextval('public.telemetria_iot_particionada_id_telemetria_seq'::regclass) NOT NULL,
    id_equipo integer NOT NULL,
    fecha_hora_registro timestamp without time zone NOT NULL,
    coordenadas_gps point,
    horometro_sensor_iot numeric(12,2),
    voltaje_bateria numeric(5,2)
);


ALTER TABLE public.telemetria_y2026m08 OWNER TO postgres;

--
-- TOC entry 251 (class 1259 OID 17496)
-- Name: telemetria_y2026m09; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.telemetria_y2026m09 (
    id_telemetria bigint DEFAULT nextval('public.telemetria_iot_particionada_id_telemetria_seq'::regclass) NOT NULL,
    id_equipo integer NOT NULL,
    fecha_hora_registro timestamp without time zone NOT NULL,
    coordenadas_gps point,
    horometro_sensor_iot numeric(12,2),
    voltaje_bateria numeric(5,2)
);


ALTER TABLE public.telemetria_y2026m09 OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 17222)
-- Name: usuarios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuarios (
    id_usuario integer NOT NULL,
    id_rol integer NOT NULL,
    dni character varying(8) NOT NULL,
    nombres character varying(100) NOT NULL,
    apellidos character varying(100) NOT NULL,
    email character varying(120) NOT NULL,
    password_hash character varying(255) NOT NULL,
    estado_activo boolean DEFAULT true NOT NULL
);


ALTER TABLE public.usuarios OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 17221)
-- Name: usuarios_id_usuario_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.usuarios_id_usuario_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.usuarios_id_usuario_seq OWNER TO postgres;

--
-- TOC entry 5471 (class 0 OID 0)
-- Dependencies: 219
-- Name: usuarios_id_usuario_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.usuarios_id_usuario_seq OWNED BY public.usuarios.id_usuario;


--
-- TOC entry 5130 (class 0 OID 0)
-- Name: telemetria_y2026m07; Type: TABLE ATTACH; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.telemetria_iot_particionada ATTACH PARTITION public.telemetria_y2026m07 FOR VALUES FROM ('2026-07-01 00:00:00') TO ('2026-08-01 00:00:00');


--
-- TOC entry 5131 (class 0 OID 0)
-- Name: telemetria_y2026m08; Type: TABLE ATTACH; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.telemetria_iot_particionada ATTACH PARTITION public.telemetria_y2026m08 FOR VALUES FROM ('2026-08-01 00:00:00') TO ('2026-09-01 00:00:00');


--
-- TOC entry 5132 (class 0 OID 0)
-- Name: telemetria_y2026m09; Type: TABLE ATTACH; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.telemetria_iot_particionada ATTACH PARTITION public.telemetria_y2026m09 FOR VALUES FROM ('2026-09-01 00:00:00') TO ('2026-10-01 00:00:00');


--
-- TOC entry 5140 (class 2604 OID 17276)
-- Name: categorias_linea_amarrilla id_categoria; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categorias_linea_amarrilla ALTER COLUMN id_categoria SET DEFAULT nextval('public.categorias_linea_amarrilla_id_categoria_seq'::regclass);


--
-- TOC entry 5154 (class 2604 OID 17390)
-- Name: check_in_retornos id_retorno; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.check_in_retornos ALTER COLUMN id_retorno SET DEFAULT nextval('public.check_in_retornos_id_retorno_seq'::regclass);


--
-- TOC entry 5152 (class 2604 OID 17369)
-- Name: check_out_salidas id_salida; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.check_out_salidas ALTER COLUMN id_salida SET DEFAULT nextval('public.check_out_salidas_id_salida_seq'::regclass);


--
-- TOC entry 5136 (class 2604 OID 17244)
-- Name: clientes_corporativos id_cliente; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientes_corporativos ALTER COLUMN id_cliente SET DEFAULT nextval('public.clientes_corporativos_id_cliente_seq'::regclass);


--
-- TOC entry 5137 (class 2604 OID 17255)
-- Name: contratos id_contrato; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contratos ALTER COLUMN id_contrato SET DEFAULT nextval('public.contratos_id_contrato_seq'::regclass);


--
-- TOC entry 5143 (class 2604 OID 17302)
-- Name: documentos_legales id_documento; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.documentos_legales ALTER COLUMN id_documento SET DEFAULT nextval('public.documentos_legales_id_documento_seq'::regclass);


--
-- TOC entry 5141 (class 2604 OID 17285)
-- Name: equipos id_equipo; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equipos ALTER COLUMN id_equipo SET DEFAULT nextval('public.equipos_id_equipo_seq'::regclass);


--
-- TOC entry 5145 (class 2604 OID 17316)
-- Name: estado_actual_equipos id_estado; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.estado_actual_equipos ALTER COLUMN id_estado SET DEFAULT nextval('public.estado_actual_equipos_id_estado_seq'::regclass);


--
-- TOC entry 5157 (class 2604 OID 17412)
-- Name: inspecciones_pwa id_inspeccion; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inspecciones_pwa ALTER COLUMN id_inspeccion SET DEFAULT nextval('public.inspecciones_pwa_id_inspeccion_seq'::regclass);


--
-- TOC entry 5147 (class 2604 OID 17332)
-- Name: items_contrato id_item; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.items_contrato ALTER COLUMN id_item SET DEFAULT nextval('public.items_contrato_id_item_seq'::regclass);


--
-- TOC entry 5159 (class 2604 OID 17434)
-- Name: liquidaciones_financieras id_liquidacion; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.liquidaciones_financieras ALTER COLUMN id_liquidacion SET DEFAULT nextval('public.liquidaciones_financieras_id_liquidacion_seq'::regclass);


--
-- TOC entry 5162 (class 2604 OID 17452)
-- Name: mantenimientos_taller id_mantenimiento; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mantenimientos_taller ALTER COLUMN id_mantenimiento SET DEFAULT nextval('public.mantenimientos_taller_id_mantenimiento_seq'::regclass);


--
-- TOC entry 5150 (class 2604 OID 17352)
-- Name: reservas_gantt id_reserva; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reservas_gantt ALTER COLUMN id_reserva SET DEFAULT nextval('public.reservas_gantt_id_reserva_seq'::regclass);


--
-- TOC entry 5133 (class 2604 OID 17216)
-- Name: roles id_rol; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles ALTER COLUMN id_rol SET DEFAULT nextval('public.roles_id_rol_seq'::regclass);


--
-- TOC entry 5164 (class 2604 OID 17470)
-- Name: telemetria_iot_particionada id_telemetria; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.telemetria_iot_particionada ALTER COLUMN id_telemetria SET DEFAULT nextval('public.telemetria_iot_particionada_id_telemetria_seq'::regclass);


--
-- TOC entry 5134 (class 2604 OID 17225)
-- Name: usuarios id_usuario; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios ALTER COLUMN id_usuario SET DEFAULT nextval('public.usuarios_id_usuario_seq'::regclass);


--
-- TOC entry 5424 (class 0 OID 17273)
-- Dependencies: 226
-- Data for Name: categorias_linea_amarrilla; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.categorias_linea_amarrilla (id_categoria, nombre_categoria, descripcion) FROM stdin;
1	Excavadoras	Equipos de excavación hidráulica
2	Bulldozer	Tractores de empuje
3	Cargadores Frontales	Cargadores de ruedas
4	Motoniveladoras	Nivelación de plataformas
\.


--
-- TOC entry 5438 (class 0 OID 17387)
-- Dependencies: 240
-- Data for Name: check_in_retornos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.check_in_retornos (id_retorno, id_salida, id_usuario_mecanico, fecha_recepcion, horometro_final, estado_devolucion) FROM stdin;
1	1	2	2026-07-15 18:40:00	5350.75	CONFORME
2	2	1	2026-08-08 01:15:55.89271	9450.00	CONFORME
\.


--
-- TOC entry 5436 (class 0 OID 17366)
-- Dependencies: 238
-- Data for Name: check_out_salidas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.check_out_salidas (id_salida, id_reserva, id_usuario_mecanico, fecha_despacho, horometro_inicial) FROM stdin;
1	1	2	2026-07-01 08:15:00	5230.50
2	7	1	2026-08-08 01:15:55.847088	9320.75
\.


--
-- TOC entry 5420 (class 0 OID 17241)
-- Dependencies: 222
-- Data for Name: clientes_corporativos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.clientes_corporativos (id_cliente, ruc, razon_social, direccion_fiscal, telefono, email_contacto) FROM stdin;
1	20512345678	Consorcio Constructor Los Andes	Av. Mariscal Cáceres Km 3, Huamanga	066-311222	logistica@consorcioandes.pe
2	20498765432	Minera Ayacucho S.A.C.	Jr. Libertad 456, Huamanga	066-315555	contratos@mineraayacucho.pe
\.


--
-- TOC entry 5422 (class 0 OID 17252)
-- Dependencies: 224
-- Data for Name: contratos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contratos (id_contrato, id_cliente, id_usuario_creador, fecha_emision, fecha_inicio, fecha_fin, estado_contrato) FROM stdin;
1	1	1	2026-06-25	2026-07-01	2026-09-30	ACTIVO
2	2	1	2026-07-05	2026-07-10	2026-08-31	ACTIVO
\.


--
-- TOC entry 5428 (class 0 OID 17299)
-- Dependencies: 230
-- Data for Name: documentos_legales; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.documentos_legales (id_documento, id_equipo, tipo_poliza, numero_poliza, fecha_vencimiento, estado_legal) FROM stdin;
1	1	SOAT	SOAT-2026-00123	2026-12-31	VIGENTE
2	1	TREC	TREC-2026-00456	2026-10-31	VIGENTE
3	2	SOAT	SOAT-2025-00789	2026-06-30	VENCIDO
4	3	SOAT	SOAT-2026-00321	2026-12-31	VIGENTE
5	4	SOAT	SOAT-2026-00654	2026-11-30	VIGENTE
6	5	TREC	TREC-2026-00987	2026-09-30	VIGENTE
\.


--
-- TOC entry 5426 (class 0 OID 17282)
-- Dependencies: 228
-- Data for Name: equipos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.equipos (id_equipo, id_categoria, codigo_patrimonial, marca, modelo, anio_fabricacion, horometro_acumulado) FROM stdin;
1	1	EX-001	Caterpillar	320GC	2021	5230.50
2	1	EX-002	Komatsu	PC210LC	2020	7812.00
3	2	BD-001	Caterpillar	D8T	2019	9320.75
4	3	CL-001	Volvo	L90H	2022	3105.25
5	4	MG-001	Caterpillar	140K	2018	11240.00
\.


--
-- TOC entry 5430 (class 0 OID 17313)
-- Dependencies: 232
-- Data for Name: estado_actual_equipos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.estado_actual_equipos (id_estado, id_equipo, estatus_operativo, ubicacion_geom) FROM stdin;
1	1	ALQUILADO	(-74.2234,-13.1587)
2	2	OPERATIVO	(-74.215,-13.162)
3	3	MANTENIMIENTO	(-74.2301,-13.1495)
4	4	OPERATIVO	(-74.2275,-13.161)
5	5	OPERATIVO	(-74.2189,-13.1544)
\.


--
-- TOC entry 5440 (class 0 OID 17409)
-- Dependencies: 242
-- Data for Name: inspecciones_pwa; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inspecciones_pwa (id_inspeccion, id_salida, id_retorno, tipo_registro, evidencias_fotos, observaciones) FROM stdin;
1	1	\N	CHECK_OUT	[{"url": "https://storage.valhala.pe/insp/001-frontal.jpg", "tipo": "frontal"}]	Equipo despachado sin daños visibles
2	\N	1	CHECK_IN	[{"url": "https://storage.valhala.pe/insp/001-horometro.jpg", "tipo": "horometro"}, {"url": "https://storage.valhala.pe/insp/001-lateral.jpg", "tipo": "lateral"}]	Retorno conforme, desgaste normal
\.


--
-- TOC entry 5432 (class 0 OID 17329)
-- Dependencies: 234
-- Data for Name: items_contrato; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.items_contrato (id_item, id_contrato, id_equipo, tarifa_por_hora, horas_minimas_garantizadas, costo_flete) FROM stdin;
1	1	1	250.00	120.00	1500.00
2	1	4	180.00	100.00	900.00
3	2	5	200.00	150.00	1200.00
\.


--
-- TOC entry 5442 (class 0 OID 17431)
-- Dependencies: 244
-- Data for Name: liquidaciones_financieras; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.liquidaciones_financieras (id_liquidacion, id_retorno, horas_base_consumidas, horas_extra_calculadas, subtotal, igv, total_facturar, estado_cobro) FROM stdin;
1	1	120.25	10.50	34000.00	6120.00	40120.00	PENDIENTE
2	2	129.25	0.00	27050.00	4869.00	31919.00	PENDIENTE
\.


--
-- TOC entry 5444 (class 0 OID 17449)
-- Dependencies: 246
-- Data for Name: mantenimientos_taller; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mantenimientos_taller (id_mantenimiento, id_equipo, id_usuario_mecanico, tipo_mantenimiento, horometro_ejecucion, costo_reparacion) FROM stdin;
1	3	2	Preventivo 500h: filtros y aceite	9320.75	1850.00
\.


--
-- TOC entry 5434 (class 0 OID 17349)
-- Dependencies: 236
-- Data for Name: reservas_gantt; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reservas_gantt (id_reserva, id_item_contrato, fecha_inicio_reserva, fecha_fin_reserva, estado_reserva) FROM stdin;
1	1	2026-07-01	2026-07-15	CONFIRMADA
2	1	2026-07-16	2026-07-31	PENDIENTE
3	2	2026-07-10	2026-07-25	CONFIRMADA
4	3	2026-07-10	2026-08-10	CONFIRMADA
5	1	2026-08-10	2026-08-20	CONFIRMADA
6	2	2026-08-25	2026-08-30	CONFIRMADA
7	3	2026-09-01	2026-09-05	CONFIRMADA
\.


--
-- TOC entry 5416 (class 0 OID 17213)
-- Dependencies: 218
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (id_rol, nombre_rol, descripcion) FROM stdin;
1	ADMIN	Administrador de flota con acceso total
2	MECANICO	Mecánico de campo con acceso PWA
3	CLIENTE	Usuario corporativo B2B
\.


--
-- TOC entry 5446 (class 0 OID 17478)
-- Dependencies: 249
-- Data for Name: telemetria_y2026m07; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.telemetria_y2026m07 (id_telemetria, id_equipo, fecha_hora_registro, coordenadas_gps, horometro_sensor_iot, voltaje_bateria) FROM stdin;
1	1	2026-07-01 09:00:00	(-74.2234,-13.1587)	5231.00	12.60
2	1	2026-07-01 10:00:00	(-74.224,-13.159)	5232.25	12.40
4	2	2026-07-12 15:30:00	(-74.215,-13.162)	7815.75	11.90
\.


--
-- TOC entry 5447 (class 0 OID 17487)
-- Dependencies: 250
-- Data for Name: telemetria_y2026m08; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.telemetria_y2026m08 (id_telemetria, id_equipo, fecha_hora_registro, coordenadas_gps, horometro_sensor_iot, voltaje_bateria) FROM stdin;
3	1	2026-08-02 09:00:00	(-74.2251,-13.1601)	5290.50	12.80
\.


--
-- TOC entry 5448 (class 0 OID 17496)
-- Dependencies: 251
-- Data for Name: telemetria_y2026m09; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.telemetria_y2026m09 (id_telemetria, id_equipo, fecha_hora_registro, coordenadas_gps, horometro_sensor_iot, voltaje_bateria) FROM stdin;
\.


--
-- TOC entry 5418 (class 0 OID 17222)
-- Dependencies: 220
-- Data for Name: usuarios; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.usuarios (id_usuario, id_rol, dni, nombres, apellidos, email, password_hash, estado_activo) FROM stdin;
1	1	72345678	Diego	Obregón Arango	admin@valhala.pe	$2a$10$6eufAX1/DlXlu.wS5kv5tO2cR/KQAmaKDsZLhsVzq2geJkPh6UjiC	t
2	2	45678912	Juan	Quispe Huamán	mecanico@valhala.pe	$2a$10$vPjPS.lxwBdL5q2b/W1fe.nasofL3ofc2F.rJPHIflikuZZHIsjoa	t
3	3	45678913	María	Torres Ccahua	cliente@consorcioandes.pe	$2a$10$VkG/bwXJ6mGDOcs6fVttwOYOSO4Ad4D91.UjrITIgpJ9bcOvwnevK	t
\.


--
-- TOC entry 5472 (class 0 OID 0)
-- Dependencies: 225
-- Name: categorias_linea_amarrilla_id_categoria_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.categorias_linea_amarrilla_id_categoria_seq', 4, true);


--
-- TOC entry 5473 (class 0 OID 0)
-- Dependencies: 239
-- Name: check_in_retornos_id_retorno_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.check_in_retornos_id_retorno_seq', 2, true);


--
-- TOC entry 5474 (class 0 OID 0)
-- Dependencies: 237
-- Name: check_out_salidas_id_salida_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.check_out_salidas_id_salida_seq', 3, true);


--
-- TOC entry 5475 (class 0 OID 0)
-- Dependencies: 221
-- Name: clientes_corporativos_id_cliente_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.clientes_corporativos_id_cliente_seq', 2, true);


--
-- TOC entry 5476 (class 0 OID 0)
-- Dependencies: 223
-- Name: contratos_id_contrato_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.contratos_id_contrato_seq', 2, true);


--
-- TOC entry 5477 (class 0 OID 0)
-- Dependencies: 229
-- Name: documentos_legales_id_documento_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.documentos_legales_id_documento_seq', 6, true);


--
-- TOC entry 5478 (class 0 OID 0)
-- Dependencies: 227
-- Name: equipos_id_equipo_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.equipos_id_equipo_seq', 5, true);


--
-- TOC entry 5479 (class 0 OID 0)
-- Dependencies: 231
-- Name: estado_actual_equipos_id_estado_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.estado_actual_equipos_id_estado_seq', 5, true);


--
-- TOC entry 5480 (class 0 OID 0)
-- Dependencies: 241
-- Name: inspecciones_pwa_id_inspeccion_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.inspecciones_pwa_id_inspeccion_seq', 2, true);


--
-- TOC entry 5481 (class 0 OID 0)
-- Dependencies: 233
-- Name: items_contrato_id_item_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.items_contrato_id_item_seq', 3, true);


--
-- TOC entry 5482 (class 0 OID 0)
-- Dependencies: 243
-- Name: liquidaciones_financieras_id_liquidacion_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.liquidaciones_financieras_id_liquidacion_seq', 2, true);


--
-- TOC entry 5483 (class 0 OID 0)
-- Dependencies: 245
-- Name: mantenimientos_taller_id_mantenimiento_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.mantenimientos_taller_id_mantenimiento_seq', 1, true);


--
-- TOC entry 5484 (class 0 OID 0)
-- Dependencies: 235
-- Name: reservas_gantt_id_reserva_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.reservas_gantt_id_reserva_seq', 7, true);


--
-- TOC entry 5485 (class 0 OID 0)
-- Dependencies: 217
-- Name: roles_id_rol_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_id_rol_seq', 3, true);


--
-- TOC entry 5486 (class 0 OID 0)
-- Dependencies: 247
-- Name: telemetria_iot_particionada_id_telemetria_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.telemetria_iot_particionada_id_telemetria_seq', 4, true);


--
-- TOC entry 5487 (class 0 OID 0)
-- Dependencies: 219
-- Name: usuarios_id_usuario_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.usuarios_id_usuario_seq', 3, true);


--
-- TOC entry 5200 (class 2606 OID 17280)
-- Name: categorias_linea_amarrilla categorias_linea_amarrilla_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categorias_linea_amarrilla
    ADD CONSTRAINT categorias_linea_amarrilla_pkey PRIMARY KEY (id_categoria);


--
-- TOC entry 5224 (class 2606 OID 17397)
-- Name: check_in_retornos check_in_retornos_id_salida_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.check_in_retornos
    ADD CONSTRAINT check_in_retornos_id_salida_key UNIQUE (id_salida);


--
-- TOC entry 5226 (class 2606 OID 17395)
-- Name: check_in_retornos check_in_retornos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.check_in_retornos
    ADD CONSTRAINT check_in_retornos_pkey PRIMARY KEY (id_retorno);


--
-- TOC entry 5220 (class 2606 OID 17375)
-- Name: check_out_salidas check_out_salidas_id_reserva_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.check_out_salidas
    ADD CONSTRAINT check_out_salidas_id_reserva_key UNIQUE (id_reserva);


--
-- TOC entry 5222 (class 2606 OID 17373)
-- Name: check_out_salidas check_out_salidas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.check_out_salidas
    ADD CONSTRAINT check_out_salidas_pkey PRIMARY KEY (id_salida);


--
-- TOC entry 5194 (class 2606 OID 17248)
-- Name: clientes_corporativos clientes_corporativos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientes_corporativos
    ADD CONSTRAINT clientes_corporativos_pkey PRIMARY KEY (id_cliente);


--
-- TOC entry 5196 (class 2606 OID 17250)
-- Name: clientes_corporativos clientes_corporativos_ruc_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientes_corporativos
    ADD CONSTRAINT clientes_corporativos_ruc_key UNIQUE (ruc);


--
-- TOC entry 5198 (class 2606 OID 17261)
-- Name: contratos contratos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contratos
    ADD CONSTRAINT contratos_pkey PRIMARY KEY (id_contrato);


--
-- TOC entry 5206 (class 2606 OID 17306)
-- Name: documentos_legales documentos_legales_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.documentos_legales
    ADD CONSTRAINT documentos_legales_pkey PRIMARY KEY (id_documento);


--
-- TOC entry 5202 (class 2606 OID 17292)
-- Name: equipos equipos_codigo_patrimonial_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equipos
    ADD CONSTRAINT equipos_codigo_patrimonial_key UNIQUE (codigo_patrimonial);


--
-- TOC entry 5204 (class 2606 OID 17290)
-- Name: equipos equipos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equipos
    ADD CONSTRAINT equipos_pkey PRIMARY KEY (id_equipo);


--
-- TOC entry 5209 (class 2606 OID 17322)
-- Name: estado_actual_equipos estado_actual_equipos_id_equipo_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.estado_actual_equipos
    ADD CONSTRAINT estado_actual_equipos_id_equipo_key UNIQUE (id_equipo);


--
-- TOC entry 5211 (class 2606 OID 17320)
-- Name: estado_actual_equipos estado_actual_equipos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.estado_actual_equipos
    ADD CONSTRAINT estado_actual_equipos_pkey PRIMARY KEY (id_estado);


--
-- TOC entry 5228 (class 2606 OID 17419)
-- Name: inspecciones_pwa inspecciones_pwa_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inspecciones_pwa
    ADD CONSTRAINT inspecciones_pwa_pkey PRIMARY KEY (id_inspeccion);


--
-- TOC entry 5213 (class 2606 OID 17337)
-- Name: items_contrato items_contrato_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.items_contrato
    ADD CONSTRAINT items_contrato_pkey PRIMARY KEY (id_item);


--
-- TOC entry 5230 (class 2606 OID 17442)
-- Name: liquidaciones_financieras liquidaciones_financieras_id_retorno_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.liquidaciones_financieras
    ADD CONSTRAINT liquidaciones_financieras_id_retorno_key UNIQUE (id_retorno);


--
-- TOC entry 5232 (class 2606 OID 17440)
-- Name: liquidaciones_financieras liquidaciones_financieras_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.liquidaciones_financieras
    ADD CONSTRAINT liquidaciones_financieras_pkey PRIMARY KEY (id_liquidacion);


--
-- TOC entry 5234 (class 2606 OID 17455)
-- Name: mantenimientos_taller mantenimientos_taller_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mantenimientos_taller
    ADD CONSTRAINT mantenimientos_taller_pkey PRIMARY KEY (id_mantenimiento);


--
-- TOC entry 5216 (class 2606 OID 17357)
-- Name: reservas_gantt reservas_gantt_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reservas_gantt
    ADD CONSTRAINT reservas_gantt_pkey PRIMARY KEY (id_reserva);


--
-- TOC entry 5218 (class 2606 OID 17364)
-- Name: reservas_gantt reservas_sin_colision; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reservas_gantt
    ADD CONSTRAINT reservas_sin_colision EXCLUDE USING gist (id_item_contrato WITH =, daterange(fecha_inicio_reserva, fecha_fin_reserva, '[]'::text) WITH &&) WHERE (((estado_reserva)::text <> 'ANULADA'::text));


--
-- TOC entry 5184 (class 2606 OID 17220)
-- Name: roles roles_nombre_rol_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_nombre_rol_key UNIQUE (nombre_rol);


--
-- TOC entry 5186 (class 2606 OID 17218)
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id_rol);


--
-- TOC entry 5237 (class 2606 OID 17472)
-- Name: telemetria_iot_particionada telemetria_iot_particionada_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.telemetria_iot_particionada
    ADD CONSTRAINT telemetria_iot_particionada_pkey PRIMARY KEY (id_telemetria, fecha_hora_registro);


--
-- TOC entry 5240 (class 2606 OID 17483)
-- Name: telemetria_y2026m07 telemetria_y2026m07_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.telemetria_y2026m07
    ADD CONSTRAINT telemetria_y2026m07_pkey PRIMARY KEY (id_telemetria, fecha_hora_registro);


--
-- TOC entry 5243 (class 2606 OID 17492)
-- Name: telemetria_y2026m08 telemetria_y2026m08_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.telemetria_y2026m08
    ADD CONSTRAINT telemetria_y2026m08_pkey PRIMARY KEY (id_telemetria, fecha_hora_registro);


--
-- TOC entry 5246 (class 2606 OID 17501)
-- Name: telemetria_y2026m09 telemetria_y2026m09_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.telemetria_y2026m09
    ADD CONSTRAINT telemetria_y2026m09_pkey PRIMARY KEY (id_telemetria, fecha_hora_registro);


--
-- TOC entry 5188 (class 2606 OID 17232)
-- Name: usuarios usuarios_dni_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_dni_key UNIQUE (dni);


--
-- TOC entry 5190 (class 2606 OID 17234)
-- Name: usuarios usuarios_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_email_key UNIQUE (email);


--
-- TOC entry 5192 (class 2606 OID 17230)
-- Name: usuarios usuarios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (id_usuario);


--
-- TOC entry 5207 (class 1259 OID 17506)
-- Name: idx_docs_vencimiento; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_docs_vencimiento ON public.documentos_legales USING btree (id_equipo, fecha_vencimiento);


--
-- TOC entry 5214 (class 1259 OID 17505)
-- Name: idx_reservas_fechas; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_reservas_fechas ON public.reservas_gantt USING btree (id_item_contrato, fecha_inicio_reserva, fecha_fin_reserva);


--
-- TOC entry 5235 (class 1259 OID 17507)
-- Name: idx_telemetria_equipo; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_telemetria_equipo ON ONLY public.telemetria_iot_particionada USING btree (id_equipo, fecha_hora_registro);


--
-- TOC entry 5238 (class 1259 OID 17508)
-- Name: telemetria_y2026m07_id_equipo_fecha_hora_registro_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX telemetria_y2026m07_id_equipo_fecha_hora_registro_idx ON public.telemetria_y2026m07 USING btree (id_equipo, fecha_hora_registro);


--
-- TOC entry 5241 (class 1259 OID 17509)
-- Name: telemetria_y2026m08_id_equipo_fecha_hora_registro_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX telemetria_y2026m08_id_equipo_fecha_hora_registro_idx ON public.telemetria_y2026m08 USING btree (id_equipo, fecha_hora_registro);


--
-- TOC entry 5244 (class 1259 OID 17510)
-- Name: telemetria_y2026m09_id_equipo_fecha_hora_registro_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX telemetria_y2026m09_id_equipo_fecha_hora_registro_idx ON public.telemetria_y2026m09 USING btree (id_equipo, fecha_hora_registro);


--
-- TOC entry 5247 (class 0 OID 0)
-- Name: telemetria_y2026m07_id_equipo_fecha_hora_registro_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.idx_telemetria_equipo ATTACH PARTITION public.telemetria_y2026m07_id_equipo_fecha_hora_registro_idx;


--
-- TOC entry 5248 (class 0 OID 0)
-- Name: telemetria_y2026m07_pkey; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.telemetria_iot_particionada_pkey ATTACH PARTITION public.telemetria_y2026m07_pkey;


--
-- TOC entry 5249 (class 0 OID 0)
-- Name: telemetria_y2026m08_id_equipo_fecha_hora_registro_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.idx_telemetria_equipo ATTACH PARTITION public.telemetria_y2026m08_id_equipo_fecha_hora_registro_idx;


--
-- TOC entry 5250 (class 0 OID 0)
-- Name: telemetria_y2026m08_pkey; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.telemetria_iot_particionada_pkey ATTACH PARTITION public.telemetria_y2026m08_pkey;


--
-- TOC entry 5251 (class 0 OID 0)
-- Name: telemetria_y2026m09_id_equipo_fecha_hora_registro_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.idx_telemetria_equipo ATTACH PARTITION public.telemetria_y2026m09_id_equipo_fecha_hora_registro_idx;


--
-- TOC entry 5252 (class 0 OID 0)
-- Name: telemetria_y2026m09_pkey; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.telemetria_iot_particionada_pkey ATTACH PARTITION public.telemetria_y2026m09_pkey;


--
-- TOC entry 5264 (class 2606 OID 17398)
-- Name: check_in_retornos check_in_retornos_id_salida_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.check_in_retornos
    ADD CONSTRAINT check_in_retornos_id_salida_fkey FOREIGN KEY (id_salida) REFERENCES public.check_out_salidas(id_salida);


--
-- TOC entry 5265 (class 2606 OID 17403)
-- Name: check_in_retornos check_in_retornos_id_usuario_mecanico_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.check_in_retornos
    ADD CONSTRAINT check_in_retornos_id_usuario_mecanico_fkey FOREIGN KEY (id_usuario_mecanico) REFERENCES public.usuarios(id_usuario);


--
-- TOC entry 5262 (class 2606 OID 17376)
-- Name: check_out_salidas check_out_salidas_id_reserva_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.check_out_salidas
    ADD CONSTRAINT check_out_salidas_id_reserva_fkey FOREIGN KEY (id_reserva) REFERENCES public.reservas_gantt(id_reserva);


--
-- TOC entry 5263 (class 2606 OID 17381)
-- Name: check_out_salidas check_out_salidas_id_usuario_mecanico_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.check_out_salidas
    ADD CONSTRAINT check_out_salidas_id_usuario_mecanico_fkey FOREIGN KEY (id_usuario_mecanico) REFERENCES public.usuarios(id_usuario);


--
-- TOC entry 5254 (class 2606 OID 17262)
-- Name: contratos contratos_id_cliente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contratos
    ADD CONSTRAINT contratos_id_cliente_fkey FOREIGN KEY (id_cliente) REFERENCES public.clientes_corporativos(id_cliente);


--
-- TOC entry 5255 (class 2606 OID 17267)
-- Name: contratos contratos_id_usuario_creador_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contratos
    ADD CONSTRAINT contratos_id_usuario_creador_fkey FOREIGN KEY (id_usuario_creador) REFERENCES public.usuarios(id_usuario);


--
-- TOC entry 5257 (class 2606 OID 17307)
-- Name: documentos_legales documentos_legales_id_equipo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.documentos_legales
    ADD CONSTRAINT documentos_legales_id_equipo_fkey FOREIGN KEY (id_equipo) REFERENCES public.equipos(id_equipo);


--
-- TOC entry 5256 (class 2606 OID 17293)
-- Name: equipos equipos_id_categoria_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equipos
    ADD CONSTRAINT equipos_id_categoria_fkey FOREIGN KEY (id_categoria) REFERENCES public.categorias_linea_amarrilla(id_categoria);


--
-- TOC entry 5258 (class 2606 OID 17323)
-- Name: estado_actual_equipos estado_actual_equipos_id_equipo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.estado_actual_equipos
    ADD CONSTRAINT estado_actual_equipos_id_equipo_fkey FOREIGN KEY (id_equipo) REFERENCES public.equipos(id_equipo);


--
-- TOC entry 5266 (class 2606 OID 17425)
-- Name: inspecciones_pwa inspecciones_pwa_id_retorno_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inspecciones_pwa
    ADD CONSTRAINT inspecciones_pwa_id_retorno_fkey FOREIGN KEY (id_retorno) REFERENCES public.check_in_retornos(id_retorno);


--
-- TOC entry 5267 (class 2606 OID 17420)
-- Name: inspecciones_pwa inspecciones_pwa_id_salida_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inspecciones_pwa
    ADD CONSTRAINT inspecciones_pwa_id_salida_fkey FOREIGN KEY (id_salida) REFERENCES public.check_out_salidas(id_salida);


--
-- TOC entry 5259 (class 2606 OID 17338)
-- Name: items_contrato items_contrato_id_contrato_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.items_contrato
    ADD CONSTRAINT items_contrato_id_contrato_fkey FOREIGN KEY (id_contrato) REFERENCES public.contratos(id_contrato);


--
-- TOC entry 5260 (class 2606 OID 17343)
-- Name: items_contrato items_contrato_id_equipo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.items_contrato
    ADD CONSTRAINT items_contrato_id_equipo_fkey FOREIGN KEY (id_equipo) REFERENCES public.equipos(id_equipo);


--
-- TOC entry 5268 (class 2606 OID 17443)
-- Name: liquidaciones_financieras liquidaciones_financieras_id_retorno_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.liquidaciones_financieras
    ADD CONSTRAINT liquidaciones_financieras_id_retorno_fkey FOREIGN KEY (id_retorno) REFERENCES public.check_in_retornos(id_retorno);


--
-- TOC entry 5269 (class 2606 OID 17456)
-- Name: mantenimientos_taller mantenimientos_taller_id_equipo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mantenimientos_taller
    ADD CONSTRAINT mantenimientos_taller_id_equipo_fkey FOREIGN KEY (id_equipo) REFERENCES public.equipos(id_equipo);


--
-- TOC entry 5270 (class 2606 OID 17461)
-- Name: mantenimientos_taller mantenimientos_taller_id_usuario_mecanico_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mantenimientos_taller
    ADD CONSTRAINT mantenimientos_taller_id_usuario_mecanico_fkey FOREIGN KEY (id_usuario_mecanico) REFERENCES public.usuarios(id_usuario);


--
-- TOC entry 5261 (class 2606 OID 17358)
-- Name: reservas_gantt reservas_gantt_id_item_contrato_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reservas_gantt
    ADD CONSTRAINT reservas_gantt_id_item_contrato_fkey FOREIGN KEY (id_item_contrato) REFERENCES public.items_contrato(id_item);


--
-- TOC entry 5271 (class 2606 OID 17473)
-- Name: telemetria_iot_particionada telemetria_iot_particionada_id_equipo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.telemetria_iot_particionada
    ADD CONSTRAINT telemetria_iot_particionada_id_equipo_fkey FOREIGN KEY (id_equipo) REFERENCES public.equipos(id_equipo);


--
-- TOC entry 5253 (class 2606 OID 17235)
-- Name: usuarios usuarios_id_rol_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_id_rol_fkey FOREIGN KEY (id_rol) REFERENCES public.roles(id_rol);


-- Completed on 2026-08-24 17:08:59

--
-- PostgreSQL database dump complete
--

