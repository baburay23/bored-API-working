import { select } from "async"

describe('the home page', () => {
    it ('sucessfully loads', () => {
         cy.visit('http://localhost:8000/src/Main.elm')
  })
it ("check dropdown list is working", () => {
    cy.visit('http://localhost:8000/src/Main.elm'),
    cy.get('select').select('education')
    cy.get('select').select('music')
})
 it ("reloads page and a new activity is given", ()=>{
     cy.visit('http://localhost:8000/src/Main.elm'),
     cy.get('text a.name').should('be.visible')
     cy.reload()
     cy.get('text a.name').should('be.visible')
 })
 })
