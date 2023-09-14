import React, { useState, useEffect } from "react";
import { Link, useNavigate } from "react-router-dom";

const Offers = () => {
  const navigate = useNavigate();
  const [offers, setOffers] = useState([]);
  const [chosenOffers, setChosenOffers] = useState([]);

  useEffect(() => {
    const url = "/api/v1/offers/index";
    fetch(url)
      .then((res) => {
        if (res.ok) {
          return res.json();
        }
        throw new Error("Network response was not OK.");
      })
      .then((res) => {
        setOffers(res.available_offers);
        setChosenOffers(res.chosen_offers);
      })
      .catch(() => {navigate("/users/sign_up"); window.location.reload(false);});
  }, []);

  const authToken = document.querySelector('meta[name="csrf-token"]').content;

  const chooseOffer = (chosenId) => {
    fetch("/api/v1/offers/choose_offer", {
      method: 'POST',
      headers: {
        "X-CSRF-Token": authToken,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        offer_id: chosenId,
      })
    })
      .then((res) => {
        if (res.ok) {
          return res.json();
        }
        throw new Error("Network response was not OK.");
      })
      .then((res) => {
        setOffers(res.available_offers);
        setChosenOffers(res.chosen_offers);
      })
      .catch((err) => console.log('error'))
  }

  const allOffers = offers.map((offer, index) => (
    <div key={index} className="col-md-6 col-lg-4">
      <div className="card mb-4">
        <div className="card-body">
          <h2 className="card-title">{offer.description}</h2>
          <p>Targeted To {offer.criterion_display}</p>
          <button className="btn btn-lg custom-button" onClick={() => {
            chooseOffer(offer.id)
          }}>
            I'M IN!
          </button>
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

  const allChosenOffers = chosenOffers.map((offer, index) => (
    <div key={index} className="col-md-6 col-lg-4">
      <div className="card mb-4">
        <div className="card-body">
          <h2 className="card-title">{offer.description}</h2>
          <p>Chosen on {offer.chosen_on}</p>
        </div>
      </div>
    </div>
  ));
  const noneChosen = (
    <div className="vw-100 vh-50 d-flex align-items-center justify-content-center">
      <h4>
        No offers chosen yet.
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
          <div className="border" />
          <span className="content">
            <h3 style={{marginTop: "0.5rem"}} >Offers you've chosen</h3>
          </span>
          <div className="border bottom-space" />
          <div className="row">
            {chosenOffers.length > 0 ? allChosenOffers : noneChosen}
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
