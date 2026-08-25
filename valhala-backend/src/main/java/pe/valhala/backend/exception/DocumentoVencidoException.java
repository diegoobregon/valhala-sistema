package pe.valhala.backend.exception;
public class DocumentoVencidoException extends RuntimeException {
    public DocumentoVencidoException() { super("RF-06: Bloqueo de despacho. El equipo tiene documentos legales (SOAT/TREC) vencidos."); }
}