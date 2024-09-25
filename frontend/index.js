import { backend } from 'declarations/backend';

const form = document.getElementById('add-item-form');
const input = document.getElementById('new-item');
const list = document.getElementById('shopping-list');

async function refreshList() {
  const items = await backend.getItems();
  list.innerHTML = '';
  items.forEach(item => {
    const li = document.createElement('li');
    li.innerHTML = `
      <span class="${item.completed ? 'completed' : ''}">${item.name}</span>
      <button class="toggle"><i class="fas fa-check"></i></button>
      <button class="delete"><i class="fas fa-trash"></i></button>
    `;
    li.querySelector('.toggle').addEventListener('click', async () => {
      await backend.toggleItem(item.id);
      refreshList();
    });
    li.querySelector('.delete').addEventListener('click', async () => {
      await backend.deleteItem(item.id);
      refreshList();
    });
    list.appendChild(li);
  });
}

form.addEventListener('submit', async (e) => {
  e.preventDefault();
  const name = input.value.trim();
  if (name) {
    await backend.addItem(name);
    input.value = '';
    refreshList();
  }
});

refreshList();
