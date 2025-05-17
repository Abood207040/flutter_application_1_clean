const functions = require("firebase-functions");
const admin = require("firebase-admin");
const nodemailer = require("nodemailer");

admin.initializeApp();

const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: "mahdyomar14@gmail.com",
    pass: "Mahdyomar14!", // App Password من Gmail
  },
});

exports.sendBookingStatusEmail = functions.firestore
  .document("bookings/{bookingId}")
  .onUpdate((change, context) => {
    const newValue = change.after.data();
    const oldValue = change.before.data();

    if (newValue.status !== oldValue.status) {
      const email = newValue.email;
      const status = newValue.status;

      const mailOptions = {
        from: "YOUR_EMAIL@gmail.com",
        to: email,
        subject: "Booking Status Updated",
        text: `Dear user,\n\nYour booking status is now: ${status}\n\nThank you!`,
      };

      return transporter.sendMail(mailOptions)
        .then(() => console.log("✅ Email sent to", email))
        .catch((error) => console.error("❌ Failed to send email:", error));
    }

    return null;
  });
