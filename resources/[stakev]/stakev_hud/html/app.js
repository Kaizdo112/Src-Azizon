const $ = (id) => document.getElementById(id);
const fmt = (n) => Math.floor(n || 0).toLocaleString('vi-VN') + ' $';
const ARC = 245; // độ dài cung của đồng hồ (khớp stroke-dasharray trong CSS)

function setStat(key, value) {
  const el = document.querySelector(`.stat[data-k="${key}"]`);
  if (!el) return;
  const v = Math.max(0, Math.min(100, value));
  el.querySelector('.bar span').style.width = v + '%';
  el.classList.toggle('low', key !== 'armor' && v <= 20);
  if (key === 'armor') el.classList.toggle('hidden', v <= 0);
}

window.addEventListener('message', ({ data }) => {
  switch (data.action) {
    case 'show':
      $('hud').classList.remove('hidden');
      if (data.id !== undefined) $('pid').textContent = data.id;
      break;
    case 'hide':
      $('hud').classList.add('hidden');
      break;
    case 'update': {
      ['health', 'armor', 'hunger', 'thirst'].forEach((k) => setStat(k, data[k]));
      $('cash').textContent = fmt(data.cash);
      $('bank').textContent = fmt(data.bank);
      $('job').textContent = data.job || '';
      $('street').textContent = data.street || '-';
      $('zone').textContent = data.zone || '-';
      $('time').textContent = data.time;

      const v = data.vehicle;
      $('speedo').classList.toggle('hidden', !v);
      if (v) {
        $('speed').textContent = v.speed;
        $('gear').textContent = v.speed === 0 ? 'N' : (v.gear === 0 ? 'R' : v.gear);
        $('fuel').style.width = v.fuel + '%';
        const rpm = $('rpm');
        rpm.style.strokeDasharray = `${ARC * v.rpm} 327`;
        rpm.classList.toggle('redline', v.rpm > 0.9);
      }
      break;
    }
  }
});
