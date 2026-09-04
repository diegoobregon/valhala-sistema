package pe.valhala.backend.exception;
public class EmpresaNoVerificadaException extends RuntimeException {
    public EmpresaNoVerificadaException() { super("La empresa aún no ha verificado su correo electrónico"); }
}