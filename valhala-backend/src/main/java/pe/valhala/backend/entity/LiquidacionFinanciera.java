package pe.valhala.backend.entity;
import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;
@Entity @Table(name = "liquidaciones_financieras") @Data @NoArgsConstructor @AllArgsConstructor
public class LiquidacionFinanciera {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY) @Column(name = "id_liquidacion") private Integer idLiquidacion;
    @OneToOne(fetch = FetchType.LAZY) @JoinColumn(name = "id_retorno", nullable = false, unique = true) private CheckInRetorno retorno;
    @Column(name = "horas_base_consumidas", nullable = false, precision = 10, scale = 2) private BigDecimal horasBaseConsumidas;
    @Column(name = "horas_extra_calculadas", nullable = false, precision = 10, scale = 2) private BigDecimal horasExtraCalculadas = BigDecimal.ZERO;
    @Column(nullable = false, precision = 12, scale = 2) private BigDecimal subtotal;
    @Column(nullable = false, precision = 12, scale = 2) private BigDecimal igv;
    @Column(name = "total_facturar", nullable = false, precision = 12, scale = 2) private BigDecimal totalFacturar;
    @Column(name = "estado_cobro", nullable = false, length = 20) private String estadoCobro = "PENDIENTE";
}