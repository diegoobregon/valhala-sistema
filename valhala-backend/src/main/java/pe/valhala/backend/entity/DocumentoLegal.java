package pe.valhala.backend.entity;
import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDate;
@Entity @Table(name = "documentos_legales") @Data @NoArgsConstructor @AllArgsConstructor
public class DocumentoLegal {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY) @Column(name = "id_documento") private Integer idDocumento;
    @ManyToOne(fetch = FetchType.LAZY) @JoinColumn(name = "id_equipo", nullable = false) private Equipo equipo;
    @Column(name = "tipo_poliza", nullable = false, length = 50) private String tipoPoliza;
    @Column(name = "numero_poliza", nullable = false, length = 50) private String numeroPoliza;
    @Column(name = "fecha_vencimiento", nullable = false) private LocalDate fechaVencimiento;
    @Column(name = "estado_legal", nullable = false, length = 20) private String estadoLegal = "VIGENTE";
}