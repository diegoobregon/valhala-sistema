package pe.valhala.backend.entity;
import lombok.*;
import java.io.Serializable;
import java.time.LocalDateTime;
@Data @NoArgsConstructor @AllArgsConstructor
public class TelemetriaIotId implements Serializable {
    private Long idTelemetria;
    private LocalDateTime fechaHoraRegistro;
}