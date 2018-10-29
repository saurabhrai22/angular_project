import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { AppComponent } from './app.component';
import { HomeComponent } from './home/home.component';
import { AboutComponent } from './about/about.component';
import { Routes,RouterModule } from '@angular/router';
import { ContactComponent } from './contact/contact.component'


const ROUTES: Routes = [

{ path:"",component:HomeComponent },
{ path:"about",component:AboutComponent },
{ path:"contact",component:ContactComponent }


]

@NgModule({
  declarations: [
    AppComponent,
    HomeComponent,
    AboutComponent,
    ContactComponent
  ],
  imports: [
    BrowserModule,
	RouterModule.forRoot(ROUTES)
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
