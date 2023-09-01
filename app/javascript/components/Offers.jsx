import React, { useState, useEffect } from "react";
import { Link, useNavigate } from "react-router-dom";

const Offers = () => {
  const navigate = useNavigate();
  const [offers, setOffers] = useState([]);

  useEffect(() => {
    const url = "/api/v1/offers/index";
    fetch(url)
      .then((res) => {
        if (res.ok) {
          return res.json();
        }
        throw new Error("Network response was not OK.");
      })
      .then((res) => setOffers(res))
      .catch(() => {navigate("/users/sign_up"); window.location.reload(false);});
  }, []);

  const allOffers = offers.map((offer, index) => (
    <div key={index} className="col-md-6 col-lg-4">
      <div className="card mb-4">
        <div className="card-body">
          <h5 className="card-title">{offer.description}</h5>
        </div>
      </div>
    </div>
  ));
  const noOffer = (
    <div className="vw-100 vh-50 d-flex align-items-center justify-content-center">
      <h4>
        No offers yet.
      </h4>
    </div>
  );

  return (
    <>
      <section className="jumbotron jumbotron-fluid text-center">
        <div className="container py-5">
          <h1 className="display-4">Offers for every occasion</h1>
          <p className="lead text-muted">
            We’ve pulled together our most popular offers, our latest
            additions, and our editor’s picks, so there’s sure to be something
            tempting for you to try.
          </p>
        </div>
      </section>
      <div className="py-5">
        <main className="container">
          <div className="row">
            {offers.length > 0 ? allOffers : noOffer}
          </div>
          <Link to="/" className="btn btn-link">
            Home
          </Link>
        </main>
      </div>
    </>
  );
};

export default Offers
