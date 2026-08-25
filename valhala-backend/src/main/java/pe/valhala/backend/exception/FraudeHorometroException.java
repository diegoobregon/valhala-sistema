package pe.valhala.backend.exception;
public class FraudeHorometroException extends RuntimeException {
    public FraudeHorometroException() { super("RF-05: Fraude detectado. El horometro final no puede ser menor al inicial."); }
}