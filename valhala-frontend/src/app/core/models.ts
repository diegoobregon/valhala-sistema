export interface LoginRequest  { email: string; password: string; }
export interface LoginResponse { token: string; rol: string; nombres: string; }

export interface Categoria { idCategoria: number; nombreCategoria: string; descripcion?: string; }

export interface Equipo {
  idEquipo: number;
  categoria: Categoria;
  codigoPatrimonial: string;
  marca: string;
  modelo: string;
  anioFabricacion: number;
  horometroAcumulado: number;
}

export interface Cliente {
  idCliente: number; ruc: string; razonSocial: string;
  direccionFiscal?: string; telefono?: string; emailContacto?: string;
}

export interface Usuario {
  idUsuario: number; dni: string; nombres: string; apellidos: string;
  email: string; estadoActivo: boolean; rol: { idRol: number; nombreRol: string };
}

export interface Contrato {
  idContrato: number; cliente: Cliente; usuarioCreador?: Usuario;
  fechaEmision: string; fechaInicio: string; fechaFin: string; estadoContrato: string;
}

export interface ItemContrato {
  idItem: number; contrato: Contrato; equipo: Equipo;
  tarifaPorHora: number; horasMinimasGarantizadas: number; costoFlete: number;
}

export interface ReservaGantt {
  idReserva: number; itemContrato: ItemContrato;
  fechaInicioReserva: string; fechaFinReserva: string; estadoReserva: string;
}

export interface CheckOutSalida {
  idSalida: number; reserva: ReservaGantt; usuarioMecanico?: Usuario;
  fechaDespacho: string; horometroInicial: number;
}

export interface CheckInRetorno {
  idRetorno: number; salida: CheckOutSalida;
  fechaRecepcion: string; horometroFinal: number; estadoDevolucion: string;
}

export interface Liquidacion {
  idLiquidacion: number; retorno: CheckInRetorno;
  horasBaseConsumidas: number; horasExtraCalculadas: number;
  subtotal: number; igv: number; totalFacturar: number; estadoCobro: string;
}

export interface DocumentoLegal {
  idDocumento: number; equipo: Equipo; tipoPoliza: string;
  numeroPoliza: string; fechaVencimiento: string; estadoLegal: string;
}

export interface Mantenimiento {
  idMantenimiento: number; equipo: Equipo; usuarioMecanico?: Usuario;
  tipoMantenimiento: string; horometroEjecucion: number; costoReparacion: number;
}
