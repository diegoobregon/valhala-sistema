package pe.valhala.backend.dto;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import java.math.BigDecimal;
@Data
public class CheckOutRequest {
    @NotNull private Integer idReserva;
    @NotNull private BigDecimal horometroInicial;
}