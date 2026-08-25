package pe.valhala.backend.entity;
import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;
@Entity @Table(name = "mantenimientos_taller") @Data @NoArgsConstructor @AllArgsConstructor
public class MantenimientoTaller {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY) @Column(name = "id_mantenimiento") private Integer idMantenimiento;
    @ManyToOne(fetch = FetchType.LAZY) @JoinColumn(name = "id_equipo", nullable = false) private Equipo equipo;
    @ManyToOne(fetch = FetchType.LAZY) @JoinColumn(name = "id_usuario_mecanico", nullable = false) private Usuario usuarioMecanico;
    @Column(name = "tipo_mantenimiento", nullable = false, length = 50) private String tipoMantenimiento;
    @Column(name = "horometro_ejecucion", nullable = false, precision = 12, scale = 2) private BigDecimal horometroEjecucion;
    @Column(name = "costo_reparacion", nullable = false, precision = 12, scale = 2) private BigDecimal costoReparacion = BigDecimal.ZERO;
}