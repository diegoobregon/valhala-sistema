package pe.valhala.backend.entity;
import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDate;
@Entity @Table(name = "contratos") @Data @NoArgsConstructor @AllArgsConstructor
public class Contrato {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY) @Column(name = "id_contrato") private Integer idContrato;
    @ManyToOne(fetch = FetchType.LAZY) @JoinColumn(name = "id_cliente", nullable = false) private ClienteCorporativo cliente;
    @ManyToOne(fetch = FetchType.LAZY) @JoinColumn(name = "id_usuario_creador", nullable = false) private Usuario usuarioCreador;
    @ManyToOne(fetch = FetchType.LAZY) @JoinColumn(name = "id_empresa") private Empresa empresa;
    @Column(name = "fecha_emision", nullable = false) private LocalDate fechaEmision;
    @Column(name = "fecha_inicio", nullable = false) private LocalDate fechaInicio;
    @Column(name = "fecha_fin", nullable = false) private LocalDate fechaFin;
    @Column(name = "estado_contrato", nullable = false, length = 20) private String estadoContrato = "BORRADOR";
}