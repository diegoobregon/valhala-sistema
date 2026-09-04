package pe.valhala.backend.exception;
public class EmailNoVerificadoException extends RuntimeException {
    public EmailNoVerificadoException() { super("Código de verificación inválido o ya usado"); }
}