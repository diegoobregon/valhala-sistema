package pe.valhala.backend.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

@Entity
@Table(name = "inspecciones_pwa")
@Data @NoArgsConstructor @AllArgsConstructor
public class InspeccionPwa {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_inspeccion")
    private Integer idInspeccion;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_salida")
    private CheckOutSalida salida;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_retorno")
    private CheckInRetorno retorno;

    @Column(name = "tipo_registro", nullable = false, length = 20)
    private String tipoRegistro;

    @JdbcTypeCode(SqlTypes.JSON)
    @Column(name = "evidencias_fotos", nullable = false)
    private String evidenciasFotos = "[]";

    @Column(columnDefinition = "TEXT")
    private String observaciones;
}