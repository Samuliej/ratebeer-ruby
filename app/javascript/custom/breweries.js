const BREWERIES = {};

const handleResponse = (breweries) => {
    BREWERIES.list = breweries;
    BREWERIES.show();
};

const createTableRow = (brewery) => {
    const tr = document.createElement("tr");
    tr.classList.add("tablerow");

    const breweryName = tr.appendChild((document.createElement("td")));
    breweryName.innerHTML = brewery.name;

    const year = tr.appendChild(document.createElement("td"));
    year.innerHTML = brewery.year;

    const beerCount = tr.appendChild(document.createElement("td"));
    beerCount.innerHTML = brewery.beers.count

    const active = tr.appendChild(document.createElement("td"));
    active.innerHTML = brewery.active ? "active" : "retired";

    return tr;
};

BREWERIES.show = () => {
    document.querySelectorAll(".tablerow").forEach((el) => el.remove());
    const tableBody = document.getElementById("brewerylist");

    BREWERIES.list.forEach((brewery) => {
        const tr = createTableRow(brewery);
        tableBody.appendChild(tr);
    });
};

// BREWERIES.sortByName = () => {
//     BREWERIES.list.sort((a, b) =>
//         a.name
//             .toUpperCase()
//             .localeCompare(b.name.toUpperCase())
//     );
// };
//
// BREWERIES.sortByYear = () => BREWERIES.list.sort((a, b) => a.year > b.year);
//
// BREWERIES.sortByBeerCount = () => BREWERIES.list.sort((a, b) => a.beers.count > b.beers.count);

const breweries = () => {
    if (document.querySelectorAll("#brewerylist").length < 1) return;

    fetch("breweries.json")
        .then((response) => response.json())
        .then(handleResponse);
};

export { breweries };