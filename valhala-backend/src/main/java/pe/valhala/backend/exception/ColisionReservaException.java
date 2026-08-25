package pe.valhala.backend.exception;
public class ColisionReservaException extends RuntimeException {
    public ColisionReservaException() { super("RF-01: El equipo ya tiene una reserva activa en esas fechas (Colision detectada)."); }
}