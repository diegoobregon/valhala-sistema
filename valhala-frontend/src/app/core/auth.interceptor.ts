import { HttpInterceptorFn } from '@angular/common/http';

/** RNF-05: inyecta el JWT en cada peticion saliente hacia la API. */
export const authInterceptor: HttpInterceptorFn = (req, next) => {
  const token = localStorage.getItem('valhala_token');
  if (token && req.url.startsWith('/api')) {
    req = req.clone({ setHeaders: { Authorization: `Bearer ${token}` } });
  }
  return next(req);
};
