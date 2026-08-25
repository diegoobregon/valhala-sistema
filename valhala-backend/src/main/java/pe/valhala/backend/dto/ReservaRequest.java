package pe.valhala.backend.dto;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import java.time.LocalDate;
@Data
public class ReservaRequest {
    @NotNull private Integer idItemContrato;
    @NotNull private LocalDate fechaInicio;
    @NotNull private LocalDate fechaFin;
}