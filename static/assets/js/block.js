function addBlock() {
  fetch("/blocks", {
    method: "post",
  })
    .then((res) => res.json())
    .then((data) => {
      console.log(data);

      // Kiểm tra xem table đã tồn tại chưa
      let table = document.querySelector("table");
      let noData = document.querySelector(".no-data");
      if (noData) {
        noData.remove();
      }
      if (!table) {
        // Nếu chưa có table, tạo table mới
        table = document.createElement("table");
        table.className = "table table-striped table-hover mt-2";

        // Tạo phần header cho table
        const thead = document.createElement("thead");
        thead.className = "table-dark";
        thead.innerHTML = `
          <tr>
            <th>Block ID</th>
            <th>Created At</th>
            <th>Updated At</th>
            <th>Action</th>
          </tr>
        `;
        table.appendChild(thead);

        // Tạo phần body cho table
        const tbody = document.createElement("tbody");
        table.appendChild(tbody);

        // Thêm table vào DOM (ví dụ: vào một container)
        const container = document.querySelector(".container");
        container.appendChild(table);
      }

      // Thêm hàng mới vào table
      const tableBody = table.querySelector("tbody");
      const newRow = document.createElement("tr");
      newRow.innerHTML = `
        <td>${data.block_id}</td>
        <td>${new Intl.DateTimeFormat("vi-VN", {
          year: "numeric",
          month: "2-digit",
          day: "2-digit",
          hour: "2-digit",
          minute: "2-digit",
          second: "2-digit",
          hour12: false,
          timeZone: "Asia/Ho_Chi_Minh",
        }).format(
          new Date(
            new Date(data.created_at).setHours(
              new Date(data.created_at).getHours() - 7
            )
          )
        )}</td>
        <td>${new Intl.DateTimeFormat("vi-VN", {
          year: "numeric",
          month: "2-digit",
          day: "2-digit",
          hour: "2-digit",
          minute: "2-digit",
          second: "2-digit",
          hour12: false,
          timeZone: "Asia/Ho_Chi_Minh",
        }).format(
          new Date(
            new Date(data.updated_at).setHours(
              new Date(data.updated_at).getHours() - 7
            )
          )
        )}</td>
        <td><a class="btn btn-primary btn-sm fs-5" href="/blocks/${
          data.block_id
        }">Detail</a></td>
      `;
      tableBody.appendChild(newRow);
    })
    .catch((error) => {
      console.error("Error:", error);
    });
}

function addHostService() {
  fetch("/host-service", {
    method: "post",
  })
    .then((res) => res.json())
    .then((data) => {
      console.log(data);
    });
}

function showLoading() {
  const loadingElement = document.createElement("div");
  loadingElement.id = "loading";
  loadingElement.textContent = "Đang Xóa ...";
  loadingElement.style.position = "fixed";
  loadingElement.style.top = "50%";
  loadingElement.style.left = "50%";
  loadingElement.style.transform = "translate(-50%, -50%)";
  loadingElement.style.backgroundColor = "rgba(0, 0, 0, 0.7)";
  loadingElement.style.color = "white";
  loadingElement.style.padding = "10px 20px";
  loadingElement.style.borderRadius = "5px";
  loadingElement.style.zIndex = "1000";
  document.body.appendChild(loadingElement);
}

function hideLoading() {
  const loadingElement = document.getElementById("loading");
  if (loadingElement) {
    loadingElement.remove();
  }
}

function deleteService(url, id, serviceName) {
  if (
    window.confirm(
      `Are you sure you want to delete this ${serviceName} service?`
    )
  ) {
    showLoading();
    fetch(`${url}/${id}`, {
      method: "delete",
    })
      .then((res) => res.json())
      .then((data) => {
        console.log(data);
        // window.location.reload();
      })
      .catch((error) => {
        console.error("Error:", error);
      })
      .finally(() => {
        hideLoading();
      });
  }
}

function deleteRDSService(id) {
  deleteService("/rds-services", id, "RDS");
}

function deleteHostService(id) {
  deleteService("/host-services", id, "Host");
}

function deleteLBService(id) {
  deleteService("/lb-services", id, "LB");
}

function onLoadState(type_service, id) {
  const loadingElement = document.createElement("div");
  loadingElement.textContent = "Đang loading...";
  loadingElement.id = "loading";
  document.body.appendChild(loadingElement);
  fetch(`/${type_service}-services/${id}/state`, {
    method: "post",
  })
    .then((res) => res.json())
    .then((data) => {
      const loading = document.getElementById("loading");
      if (loading) {
        loading.remove();
      }
      if (data.status == "success") {
        alert(data.state);
        document.querySelector("#state").textContent = data.state[0];
        // window.location.reload();
      } else {
        alert("Fail");
      }
    });
}

function stopService(type_service, id) {
  const loadingElement = document.createElement("div");
  loadingElement.textContent = "Đang stop...";
  loadingElement.id = "loading";
  document.body.appendChild(loadingElement);
  fetch(`/${type_service}-services/${id}`, {
    method: "post",
  })
    .then((res) => res.json())
    .then((data) => {
      const loading = document.getElementById("loading");
      if (loading) {
        loading.remove();
      }
      if (data.status == "success") {
        alert(data.state);
        document.querySelector("#state").textContent = data.state;
        // window.location.reload();
      } else {
        alert("Fail");
      }
    });
}
