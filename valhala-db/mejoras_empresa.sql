-- MEJORAS ACORDE A LA EMPRESA REAL (contrato + documentos reales)

-- Cláusula SEGUNDA: destino/obra del contrato
ALTER TABLE contratos ADD COLUMN IF NOT EXISTS obra_destino VARCHAR(255);

-- Equipo real de obra: Retroexcavadora CAT 420
INSERT INTO equipos (id_categoria, codigo_patrimonial, marca, modelo, anio_fabricacion, horometro_acumulado)
VALUES (1, 'LTG01411', 'CATERPILLAR', '420', 2021, 5.7);

-- Documentos reales: SCTR (vencido p/ demo RF-06) y Certificado de Operatividad
INSERT INTO documentos_legales (id_equipo, tipo_poliza, numero_poliza, fecha_vencimiento, estado_legal)
VALUES ((SELECT MAX(id_equipo) FROM equipos), 'SCTR', '30460908', '2026-08-23', 'VENCIDO');

INSERT INTO documentos_legales (id_equipo, tipo_poliza, numero_poliza, fecha_vencimiento, estado_legal)
VALUES ((SELECT MAX(id_equipo) FROM equipos), 'CERT_OPERATIVIDAD', 'UNIMAQ-CRS75134', '2026-12-31', 'VIGENTE');

-- Cliente real del contrato ejemplo
INSERT INTO clientes_corporativos (ruc, razon_social, direccion_fiscal, telefono, email_contacto)
VALUES ('20608330764', 'STRABAG S.A.C.', 'Jr. General Prado N°1097, Huánuco', '062512345', 'contratos@strabag.pe');

-- Contrato con obra destino
INSERT INTO contratos (id_cliente, id_usuario_creador, fecha_emision, fecha_inicio, fecha_fin, estado_contrato, obra_destino)
VALUES ((SELECT MAX(id_cliente) FROM clientes_corporativos),
        (SELECT MIN(id_usuario) FROM usuarios),
        '2026-07-07', '2026-07-08', '2027-01-04', 'ACTIVO',
        'Trabajos de construcción - Universidad Continental, Sede Ayacucho');

-- Programa de mantenimiento CAT (PM1 250h)
INSERT INTO mantenimientos_taller (id_equipo, id_usuario_mecanico, tipo_mantenimiento, horometro_ejecucion, costo_reparacion)
VALUES ((SELECT MAX(id_equipo) FROM equipos),
        (SELECT MIN(id_usuario) FROM usuarios),
        'PM1 - Servicio 250H', 250, 850.00);

-- GRE SUNAT ligada al despacho (Doc 2)
ALTER TABLE check_out_salidas ADD COLUMN IF NOT EXISTS gre_numero VARCHAR(20);
