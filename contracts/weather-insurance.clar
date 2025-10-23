;; weather-insurance
;; Issues weather policies, verifies weather data from oracles, calculates payouts, and distributes claims

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-authorized (err u101))
(define-constant err-not-found (err u102))
(define-constant err-already-claimed (err u103))
(define-constant err-not-triggered (err u104))
(define-constant err-invalid-amount (err u105))
(define-constant err-policy-expired (err u106))

;; Policy status
(define-constant status-active u1)
(define-constant status-claimed u2)
(define-constant status-expired u3)

;; Data Variables
(define-data-var policy-nonce uint u0)
(define-data-var total-premiums uint u0)
(define-data-var total-payouts uint u0)

;; Data Maps
(define-map policies
  uint
  {
    holder: principal,
    coverage-amount: uint,
    premium-paid: uint,
    threshold-value: uint,
    policy-type: (string-ascii 20),
    start-block: uint,
    end-block: uint,
    status: uint,
    location: (string-ascii 50)
  }
)

(define-map claims
  uint
  {
    policy-id: uint,
    weather-value: uint,
    verified-at: uint,
    payout-amount: uint,
    oracle: principal
  }
)

(define-map authorized-oracles
  principal
  { name: (string-ascii 100), active: bool }
)

;; Public Functions

(define-public (authorize-oracle (oracle principal) (name (string-ascii 100)))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (map-set authorized-oracles oracle { name: name, active: true })
    (ok true)
  )
)

(define-public (create-policy
  (coverage-amount uint)
  (threshold-value uint)
  (policy-type (string-ascii 20))
  (duration-blocks uint)
  (location (string-ascii 50))
)
  (let
    (
      (policy-id (var-get policy-nonce))
      (premium (/ (* coverage-amount u5) u100))
    )
    (asserts! (> coverage-amount u0) err-invalid-amount)
    (try! (stx-transfer? premium tx-sender (as-contract tx-sender)))
    
    (map-set policies policy-id {
      holder: tx-sender,
      coverage-amount: coverage-amount,
      premium-paid: premium,
      threshold-value: threshold-value,
      policy-type: policy-type,
      start-block: block-height,
      end-block: (+ block-height duration-blocks),
      status: status-active,
      location: location
    })
    
    (var-set policy-nonce (+ policy-id u1))
    (var-set total-premiums (+ (var-get total-premiums) premium))
    (ok policy-id)
  )
)

(define-public (submit-claim (policy-id uint) (weather-value uint))
  (let
    (
      (policy (unwrap! (map-get? policies policy-id) err-not-found))
      (oracle-data (unwrap! (map-get? authorized-oracles tx-sender) err-not-authorized))
    )
    (asserts! (get active oracle-data) err-not-authorized)
    (asserts! (is-eq (get status policy) status-active) err-already-claimed)
    (asserts! (<= block-height (get end-block policy)) err-policy-expired)
    (asserts! (>= weather-value (get threshold-value policy)) err-not-triggered)
    
    ;; Calculate payout
    (let ((payout-amount (get coverage-amount policy)))
      (try! (as-contract (stx-transfer? payout-amount tx-sender (get holder policy))))
      
      (map-set claims policy-id {
        policy-id: policy-id,
        weather-value: weather-value,
        verified-at: block-height,
        payout-amount: payout-amount,
        oracle: tx-sender
      })
      
      (map-set policies policy-id (merge policy { status: status-claimed }))
      (var-set total-payouts (+ (var-get total-payouts) payout-amount))
      (ok payout-amount)
    )
  )
)

(define-public (expire-policy (policy-id uint))
  (let
    ((policy (unwrap! (map-get? policies policy-id) err-not-found)))
    (asserts! (> block-height (get end-block policy)) err-invalid-amount)
    (asserts! (is-eq (get status policy) status-active) err-already-claimed)
    (map-set policies policy-id (merge policy { status: status-expired }))
    (ok true)
  )
)

;; Read-Only Functions

(define-read-only (get-policy (policy-id uint))
  (ok (unwrap! (map-get? policies policy-id) err-not-found))
)

(define-read-only (get-claim (policy-id uint))
  (ok (map-get? claims policy-id))
)

(define-read-only (is-authorized-oracle (oracle principal))
  (match (map-get? authorized-oracles oracle)
    data (ok (get active data))
    (ok false)
  )
)

(define-read-only (get-stats)
  (ok {
    total-policies: (var-get policy-nonce),
    total-premiums: (var-get total-premiums),
    total-payouts: (var-get total-payouts)
  })
)
