package pe.valhala.backend.entity;
import jakarta.persistence.*;
import lombok.*;
@Entity @Table(name = "clientes_corporativos") @Data @NoArgsConstructor @AllArgsConstructor
public class ClienteCorporativo {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY) @Column(name = "id_cliente") private Integer idCliente;
    @ManyToOne(fetch = FetchType.LAZY) @JoinColumn(name = "id_empresa") private Empresa empresa;
    @Column(nullable = false, unique = true, length = 11) private String ruc;
    @Column(name = "razon_social", nullable = false, length = 150) private String razonSocial;
    @Column(name = "direccion_fiscal") private String direccionFiscal;
    @Column(length = 20) private String telefono;
    @Column(name = "email_contacto", length = 120) private String emailContacto;
}