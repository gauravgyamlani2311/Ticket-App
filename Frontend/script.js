document.querySelector("form").addEventListener("submit", function(e) {
    const name = document.querySelector("input[name='name']").value;
    const email = document.querySelector("input[name='email']").value;

    if (name === "" || email === "") {
        alert("All fields are required!");
        e.preventDefault();
    }
});