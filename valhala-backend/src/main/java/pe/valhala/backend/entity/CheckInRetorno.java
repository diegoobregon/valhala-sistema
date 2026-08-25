package pe.valhala.backend.entity;
import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;
@Entity @Table(name = "check_in_retornos") @Data @NoArgsConstructor @AllArgsConstructor
public class CheckInRetorno {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY) @Column(name = "id_retorno") private Integer idRetorno;
    @OneToOne(fetch = FetchType.LAZY) @JoinColumn(name = "id_salida", nullable = false, unique = true) private CheckOutSalida salida;
    @ManyToOne(fetch = FetchType.LAZY) @JoinColumn(name = "id_usuario_mecanico", nullable = false) private Usuario usuarioMecanico;
    @Column(name = "fecha_recepcion", nullable = false) private LocalDateTime fechaRecepcion;
    @Column(name = "horometro_final", nullable = false, precision = 12, scale = 2) private BigDecimal horometroFinal;
    @Column(name = "estado_devolucion", nullable = false, length = 20) private String estadoDevolucion = "CONFORME";
}