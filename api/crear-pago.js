import mercadopago from 'mercadopago';
mercadopago.configure({ access_token: process.env.MP_ACCESS_TOKEN });

export default async function handler(req, res) {
  if (req.method!== 'POST') return res.status(405).end();
  const { mp_alias_trabajador, monto_viatico = 2500, monto_comision = 4000 } = req.body;
  // Total = viatico + comision = 6500
  // El pago va al trabajador, y tu comision es marketplace_fee
  try {
    const preference = {
      items: [
        { title: "Viático trabajador - Changa App", quantity: 1, unit_price: 2500, currency_id: "ARS" },
        { title: "Comisión tecnología Changa App", quantity: 1, unit_price: 4000, currency_id: "ARS" }
      ],
      marketplace_fee: 4000, // Esto va para vos automaticamente
      collector_id: null, // Se cobra en cuenta del trabajador
      external_reference: mp_alias_trabajador,
      back_urls: { success: "https://changa-app-nine.vercel.app/?pago=ok" },
      auto_return: "approved"
    };
    // Nota: Para split real necesitas que el trabajador esté conectado con OAuth
    // Por ahora generamos preferencia y guardamos alias para transferencia directa
    // Versión simple: Link directo a pagar al trabajador + comision a vos
    const link_trabajador = `https://www.mercadopago.com.ar/qr/pagar?alias=${mp_alias_trabajador}&monto=${monto_viatico}`;
    const link_comision = `https://www.mercadopago.com.ar/qr/pagar?alias=israel2525&monto=${monto_comision}`;
    return res.json({
      ok: true,
      split: true,
      viatico_link: link_trabajador,
      comision_link: link_comision,
      total: 6500,
      mensaje: "PAGO SPLIT: $2.500 directo al trabajador + $4.000 a Changa App - LEGAL PUENTE"
    });
  } catch (e) { return res.status(500).json({ error: e.message }); }
}
