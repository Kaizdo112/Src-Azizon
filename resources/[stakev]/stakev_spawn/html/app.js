const list = document.getElementById('list');
const go = document.getElementById('go');
const resource = typeof GetParentResourceName === 'function' ? GetParentResourceName() : 'stakev_spawn';
let selected = null;
let busy = false;

const post = (name, body) =>
  fetch(`https://${resource}/${name}`, { method: 'POST', body: JSON.stringify(body) }).then((r) => r.json()).catch(() => ({}));

function select(id) {
  selected = id;
  list.querySelectorAll('li').forEach((li) => li.classList.toggle('active', li.dataset.id === id));
  go.disabled = !id;
  post('preview', { id });
}

function render(options) {
  list.innerHTML = '';
  options.forEach((o) => {
    const li = document.createElement('li');
    li.dataset.id = o.id;
    li.innerHTML = `<div class="icon"></div><div><div class="name"></div><div class="desc"></div></div>`;
    li.querySelector('.icon').textContent = o.icon || '•';
    li.querySelector('.name').textContent = o.label;
    li.querySelector('.desc').textContent = o.desc || '';
    li.addEventListener('click', () => select(o.id));
    li.addEventListener('dblclick', () => { select(o.id); choose(); });
    list.appendChild(li);
  });
  if (options[0]) select(options[0].id);
}

async function choose() {
  if (!selected || busy) return;
  busy = true;
  go.disabled = true;
  await post('choose', { id: selected });
  busy = false;
  go.disabled = false;
}

go.addEventListener('click', choose);

window.addEventListener('message', ({ data }) => {
  if (data.action === 'open') {
    document.getElementById('hint').textContent = data.isNew
      ? 'Chào mừng tới StakeV! Người mới bắt đầu tại sân bay.'
      : 'Chọn một điểm để xem trước, bấm Xuất hiện để vào game.';
    render(data.options || []);
    document.getElementById('spawn').classList.remove('hidden');
  } else if (data.action === 'close') {
    document.getElementById('spawn').classList.add('hidden');
  }
});
