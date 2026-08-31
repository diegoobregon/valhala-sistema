import { Component, inject, signal, computed } from '@angular/core';
import { ApiService } from '../core/api.service';
import { Liquidacion } from '../core/models';

@Component({
  selector: 'app-liquidaciones',
  standalone: true,
  template: `
  <div class="card">
    <h2>Liquidaciones financieras</h2>
    @if (error()) {
      <div class="msg er">
        Acceso denegado (403). El modulo financiero esta restringido a los roles ADMIN y CLIENTE.
      </div>
    } @else {
      <table>
        <tr>
          <th>#</th><th>Equipo</th><th>Cliente</th><th>H. base</th><th>H. extra</th>
          <th>Subtotal S/</th><th>IGV S/</th><th>Total S/</th><th>Estado</th>
        </tr>
        @for (l of liq(); track l.idLiquidacion) {
          <tr>
            <td>{{ l.idLiquidacion }}</td>
            <td>{{ l.retorno?.salida?.reserva?.itemContrato?.equipo?.codigoPatrimonial }}</td>
            <td>{{ l.retorno?.salida?.reserva?.itemContrato?.contrato?.cliente?.razonSocial }}</td>
            <td>{{ l.horasBaseConsumidas }}</td>
            <td>{{ l.horasExtraCalculadas }}</td>
            <td>{{ l.subtotal }}</td>
            <td>{{ l.igv }}</td>
            <td><b>{{ l.totalFacturar }}</b></td>
            <td><span class="badge b-am">{{ l.estadoCobro }}</span></td>
          </tr>
        }
      </table>
      <p style="margin-top:16px;font-size:15px">
        Total facturado acumulado: <b style="color:var(--am)">S/ {{ total().toFixed(2) }}</b>
      </p>
    }
  </div>`
})
export class LiquidacionesComponent {
  private api = inject(ApiService);
  liq = signal<Liquidacion[]>([]);
  error = signal(false);
  total = computed(() => this.liq().reduce((a, l) => a + Number(l.totalFacturar ?? 0), 0));

  constructor() {
    this.api.liquidaciones().subscribe({
      next: r => this.liq.set(r),
      error: () => this.error.set(true)
    });
  }
}
