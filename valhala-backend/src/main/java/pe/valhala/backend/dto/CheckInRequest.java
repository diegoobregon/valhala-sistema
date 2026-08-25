package pe.valhala.backend.dto;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import java.math.BigDecimal;
@Data
public class CheckInRequest {
    @NotNull private Integer idSalida;
    @NotNull private BigDecimal horometroFinal;
}