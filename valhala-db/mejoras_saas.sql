CREATE TABLE IF NOT EXISTS empresas (
    id_empresa SERIAL PRIMARY KEY,
    ruc VARCHAR(11) UNIQUE NOT NULL,
    razon_social VARCHAR(150) NOT NULL,
    email_contacto VARCHAR(150) UNIQUE NOT NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'ACTIVO',
    fecha_registro TIMESTAMP NOT NULL DEFAULT NOW()
);
INSERT INTO empresas (id_empresa, ruc, razon_social, email_contacto) VALUES (1, '20615589846', 'VALHALA S.A.C.', 'admin@valhala.pe') ON CONFLICT (id_empresa) DO NOTHING;
INSERT INTO empresas (id_empresa, ruc, razon_social, email_contacto) VALUES (2, '20500000001', 'RENTALS CUSCO E.I.R.L.', 'gerencia@rentalscusco.pe') ON CONFLICT (id_empresa) DO NOTHING;
ALTER TABLE usuarios ADD COLUMN IF NOT EXISTS id_empresa INT REFERENCES empresas(id_empresa);
ALTER TABLE equipos ADD COLUMN IF NOT EXISTS id_empresa INT REFERENCES empresas(id_empresa);
ALTER TABLE clientes_corporativos ADD COLUMN IF NOT EXISTS id_empresa INT REFERENCES empresas(id_empresa);
ALTER TABLE contratos ADD COLUMN IF NOT EXISTS id_empresa INT REFERENCES empresas(id_empresa);
UPDATE usuarios SET id_empresa = 1 WHERE id_empresa IS NULL;
UPDATE equipos SET id_empresa = 1 WHERE id_empresa IS NULL;
UPDATE clientes_corporativos SET id_empresa = 1 WHERE id_empresa IS NULL;
UPDATE contratos SET id_empresa = 1 WHERE id_empresa IS NULL;
CREATE TABLE IF NOT EXISTS verificaciones_email (
    id_verificacion SERIAL PRIMARY KEY, email VARCHAR(150) NOT NULL, codigo VARCHAR(6) NOT NULL,
    creado_en TIMESTAMP NOT NULL DEFAULT NOW(), usado BOOLEAN NOT NULL DEFAULT FALSE
);
INSERT INTO usuarios (id_rol, dni, nombres, apellidos, email, password_hash, estado_activo, id_empresa)
SELECT 1, '44556677', 'Rosa', 'Quispe', 'gerencia@rentalscusco.pe', crypt('rentals123', gen_salt('bf')), true, 2
WHERE NOT EXISTS (SELECT 1 FROM usuarios WHERE email = 'gerencia@rentalscusco.pe');
INSERT INTO equipos (id_categoria, codigo_patrimonial, marca, modelo, anio_fabricacion, horometro_acumulado, id_empresa)
SELECT 1, 'RC-001', 'Komatsu', 'PC200', 2021, 1500, 2
WHERE NOT EXISTS (SELECT 1 FROM equipos WHERE codigo_patrimonial = 'RC-001');