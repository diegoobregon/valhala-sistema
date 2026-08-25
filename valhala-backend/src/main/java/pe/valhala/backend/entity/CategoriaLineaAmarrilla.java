package pe.valhala.backend.entity;
import jakarta.persistence.*;
import lombok.*;
@Entity @Table(name = "categorias_linea_amarrilla") @Data @NoArgsConstructor @AllArgsConstructor
public class CategoriaLineaAmarrilla {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY) @Column(name = "id_categoria") private Integer idCategoria;
    @Column(name = "nombre_categoria", nullable = false, length = 100) private String nombreCategoria;
    @Column(columnDefinition = "TEXT") private String descripcion;
}