const BEERS = {};

const handleResponse = (beers) => {
    BEERS.list = beers;
    BEERS.show();
};

const createTableRow = (beer) => {
    const tr = document.createElement("tr");
    tr.classList.add("tablerow");

    const beerName = tr.appendChild((document.createElement("td")));
    beerName.innerHTML = beer.name;

    const style = tr.appendChild(document.createElement("td"));
    style.innerHTML = beer.style.name;

    const brewery = tr.appendChild(document.createElement("td"));
    brewery.innerHTML = beer.brewery.name;

    return tr;
};

BEERS.show = () => {
    document.querySelectorAll(".tablerow").forEach((el) => el.remove());
    const tableBody = document.getElementById("beerlist");

    BEERS.list.forEach((beer) => {
        const tr = createTableRow(beer);
        tableBody.appendChild(tr);
    });
};

BEERS.sortByStyle = () => {
    BEERS.list.sort((a, b) =>
        a.style.name
            .toUpperCase()
            .localeCompare(b.style.name.toUpperCase())
    );
};

BEERS.sortByBrewery = () => {
    BEERS.list.sort((a, b) =>
        a.brewery.name
            .toUpperCase()
            .localeCompare(b.brewery.name.toUpperCase())
    );
};

BEERS.sortByName = () => {
    BEERS.list.sort((a, b) =>
        a.name
            .toUpperCase()
            .localeCompare(b.name.toUpperCase())
    );
};

const beers = () => {
    if (document.querySelectorAll("#beerlist").length < 1) return;

    document.getElementById("name").addEventListener("click", (e) => {
        e.preventDefault;
        BEERS.sortByName();
        BEERS.show();
    });

    document.getElementById("style").addEventListener("click", (e) => {
        e.preventDefault;
        BEERS.sortByStyle();
        BEERS.show();
    });

    document.getElementById("brewery").addEventListener("click", (e) => {
        e.preventDefault;
        BEERS.sortByBrewery();
        BEERS.show();
    });

    fetch("beers.json")
        .then((response) => response.json())
        .then(handleResponse);
};

export { beers };