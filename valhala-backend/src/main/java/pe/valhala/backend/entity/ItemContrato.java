package pe.valhala.backend.entity;
import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;
@Entity @Table(name = "items_contrato") @Data @NoArgsConstructor @AllArgsConstructor
public class ItemContrato {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY) @Column(name = "id_item") private Integer idItem;
    @ManyToOne(fetch = FetchType.LAZY) @JoinColumn(name = "id_contrato", nullable = false) private Contrato contrato;
    @ManyToOne(fetch = FetchType.LAZY) @JoinColumn(name = "id_equipo", nullable = false) private Equipo equipo;
    @Column(name = "tarifa_por_hora", nullable = false, precision = 10, scale = 2) private BigDecimal tarifaPorHora;
    @Column(name = "horas_minimas_garantizadas", nullable = false, precision = 8, scale = 2) private BigDecimal horasMinimasGarantizadas = BigDecimal.ZERO;
    @Column(name = "costo_flete", nullable = false, precision = 10, scale = 2) private BigDecimal costoFlete = BigDecimal.ZERO;
}