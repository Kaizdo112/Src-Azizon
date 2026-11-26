const form = document.getElementById('form');
const error = document.getElementById('error');
const heightVal = document.getElementById('height-val');
const resource = typeof GetParentResourceName === 'function' ? GetParentResourceName() : 'stakev_identity';

const capitalize = (s) => s.trim().toLocaleLowerCase('vi').replace(/^\p{L}/u, (c) => c.toLocaleUpperCase('vi'));

form.height.addEventListener('input', () => { heightVal.textContent = form.height.value + ' cm'; });

window.addEventListener('message', ({ data }) => {
  if (data.action === 'open') {
    const l = data.limits || {};
    if (l.HeightMin) { form.height.min = l.HeightMin; form.height.max = l.HeightMax; }
    const y = new Date().getFullYear();
    form.dateofbirth.max = `${y - (l.AgeMin || 18)}-12-31`;
    form.dateofbirth.min = `${y - (l.AgeMax || 80)}-01-01`;
    document.getElementById('creator').classList.remove('hidden');
    form.firstname.focus();
  } else if (data.action === 'close') {
    document.getElementById('creator').classList.add('hidden');
  }
});

form.addEventListener('submit', async (e) => {
  e.preventDefault();
  error.textContent = '';
  const payload = {
    firstname: capitalize(form.firstname.value),
    lastname: capitalize(form.lastname.value),
    dateofbirth: form.dateofbirth.value,
    sex: form.sex.value,
    height: Number(form.height.value),
  };
  if (!/^\p{L}+$/u.test(payload.firstname) || !/^\p{L}+$/u.test(payload.lastname)) {
    error.textContent = 'Họ và tên chỉ gồm chữ cái, không dấu cách hay số.';
    return;
  }
  const btn = form.querySelector('button');
  btn.disabled = true;
  try {
    const res = await fetch(`https://${resource}/submit`, { method: 'POST', body: JSON.stringify(payload) });
    const out = await res.json();
    if (!out.ok) error.textContent = out.error || 'Không tạo được nhân vật.';
  } catch {
    error.textContent = 'Lỗi kết nối, thử lại.';
  } finally {
    btn.disabled = false;
  }
});
