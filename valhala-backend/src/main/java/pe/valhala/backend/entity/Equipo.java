package pe.valhala.backend.entity;
import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;
@Entity @Table(name = "equipos") @Data @NoArgsConstructor @AllArgsConstructor
public class Equipo {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY) @Column(name = "id_equipo") private Integer idEquipo;
    @ManyToOne(fetch = FetchType.LAZY) @JoinColumn(name = "id_categoria", nullable = false) private CategoriaLineaAmarrilla categoria;
    @Column(name = "codigo_patrimonial", nullable = false, unique = true, length = 50) private String codigoPatrimonial;
    @Column(nullable = false, length = 50) private String marca;
    @Column(nullable = false, length = 50) private String modelo;
    @Column(name = "anio_fabricacion") private Integer anioFabricacion;
    @Column(name = "horometro_acumulado", nullable = false, precision = 12, scale = 2) private BigDecimal horometroAcumulado = BigDecimal.ZERO;
}